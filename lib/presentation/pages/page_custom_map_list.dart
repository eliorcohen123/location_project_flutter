import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locationprojectflutter/data/models/model_stream_location/user_location.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/provider_custom_map_list.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_app_bar_total.dart';
import 'package:provider/provider.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_add_edit_favorite_places.dart';

class PageCustomMapList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderCustomMapList>(
      builder: (context, results, child) {
        return PageCustomMapListProv();
      },
    );
  }
}

class PageCustomMapListProv extends StatefulWidget {
  @override
  _PageCustomMapListProvState createState() => _PageCustomMapListProvState();
}

class _PageCustomMapListProvState extends State<PageCustomMapListProv> {
  MapCreatedCallback _onMapCreated;
  LatLng _currentLocation;
  UserLocation _userLocation;
  ProviderCustomMapList _provider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<ProviderCustomMapList>(context, listen: false);
      _provider.isCheckingBottomSheet(false);
      _provider.clearMarkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    _userLocation = Provider.of<UserLocation>(context);
    _currentLocation = LatLng(_userLocation.latitude, _userLocation.longitude);
    return Scaffold(
      appBar: WidgetAppBarTotal(),
      body: Stack(
        children: [
          _googleMap(),
          _blur(),
        ],
      ),
    );
  }

  Widget _googleMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _currentLocation,
        zoom: 10.0,
      ),
      markers: Set<Marker>.of(_provider.markersGet),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomGesturesEnabled: true,
      mapType: MapType.normal,
      onTap: _addMarker,
    );
  }

  Widget _blur() {
    return _provider.isCheckingBottomSheetGet == true
        ? Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: ResponsiveScreen().widthMediaQuery(context, 5),
                sigmaY: ResponsiveScreen().widthMediaQuery(context, 5),
              ),
              child: Container(
                color: Colors.black.withOpacity(0),
              ),
            ),
          )
        : Container();
  }

  void _newTaskModalBottomSheet(BuildContext context, LatLng point) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            _provider.isCheckingBottomSheet(false);

            Navigator.pop(context, false);

            return Future.value(false);
          },
          child: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return Container(
                child: ListView(
                  children: [
                    WidgetAddEditFavoritePlaces(
                      latList: point.latitude,
                      lngList: point.longitude,
                      photoList: "",
                      edit: false,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _addMarker(LatLng point) {
    _provider.clearMarkers();
    _provider.markersGet.add(
      Marker(
        markerId: MarkerId(
          point.toString(),
        ),
        position: point,
        onTap: () => {
          _provider.isCheckingBottomSheet(true),
          _newTaskModalBottomSheet(context, point),
        },
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ),
    );
  }
}
