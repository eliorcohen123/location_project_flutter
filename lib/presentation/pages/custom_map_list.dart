import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locationprojectflutter/data/models/model_stream_location/user_location.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/custom_map_list_provider.dart';
import 'package:locationprojectflutter/presentation/widgets/appbar_total.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:provider/provider.dart';
import '../widgets/add_or_edit_favorites_places.dart';

class CustomMapList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CustomMapListProvider>(
      builder: (context, results, child) {
        return CustomMapListProv();
      },
    );
  }
}

class CustomMapListProv extends StatefulWidget {
  CustomMapListProv({Key key}) : super(key: key);

  @override
  _CustomMapListProvState createState() => _CustomMapListProvState();
}

class _CustomMapListProvState extends State<CustomMapListProv> {
  MapCreatedCallback _onMapCreated;
  bool _zoomGesturesEnabled = true;
  LatLng _currentLocation;
  var _userLocation, _provider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<CustomMapListProvider>(context, listen: false);
      _provider.isCheckingBottomSheet(false);
      _provider.clearMarkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    _userLocation = Provider.of<UserLocation>(context);
    _currentLocation = LatLng(_userLocation.latitude, _userLocation.longitude);
    return Scaffold(
      appBar: AppBarTotal(),
      body: Container(
          child: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 10.0,
            ),
            markers: Set<Marker>.of(_provider.markersGet),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomGesturesEnabled: _zoomGesturesEnabled,
            mapType: MapType.normal,
            onTap: _addMarker,
          ),
          _provider.checkingBottomSheetGet == true
              ? Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0),
                    ),
                  ),
                )
              : Container(),
        ],
      )),
      drawer: DrawerTotal(),
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
                    AddOrEditFavoritesPlaces(
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
}
