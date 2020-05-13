import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locationprojectflutter/data/models/model_stream_location/user_location.dart';
import 'package:locationprojectflutter/presentation/others/map_utils.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:provider/provider.dart';

import 'add_or_edit_data_favorites.dart';

class CustomMapList extends StatefulWidget {
  final double latList, lngList;
  final String nameList;

  CustomMapList({Key key, this.nameList, this.latList, this.lngList})
      : super(key: key);

  @override
  _CustomMapListState createState() => _CustomMapListState();
}

class _CustomMapListState extends State<CustomMapList> {
  GoogleMapController _myMapController;
  bool _zoomGesturesEnabled = true;
  List<Marker> _markers = <Marker>[];

  @override
  Widget build(BuildContext context) {
    var _userLocation = Provider.of<UserLocation>(context);
    var _currentLocation =
        LatLng(_userLocation.latitude, _userLocation.longitude);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Lovely Favorite Places',
            style: TextStyle(color: Color(0xFFE9FFFF)),
          ),
          iconTheme: new IconThemeData(color: Color(0xFFE9FFFF)),
        ),
        body: GoogleMap(
          onMapCreated: (controller) {
            setState(() {
              _myMapController = controller;
            });
          },
          initialCameraPosition: CameraPosition(
            target: _currentLocation,
            zoom: 10.0,
          ),
          markers: Set<Marker>.of(_markers),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomGesturesEnabled: _zoomGesturesEnabled,
          mapType: MapType.normal,
          onTap: _handleTap,
        ),
        drawer: DrawerTotal());
  }

  _handleTap(LatLng point) {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddOrEditDataFavorites(
                latList: point.latitude,
                lngList: point.longitude,
                edit: false,
              ),
            )),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ));
    });

    _showDialog(String namePlace, double lat, double lng) {
      return showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text(namePlace),
          content: new Text("Would you want to navigate $namePlace?"),
          actions: <Widget>[
            FlatButton(
              child: Text("לא"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("כן"),
              onPressed: () {
                MapUtils.openMap(lat, lng);
              },
            ),
          ],
        ),
      );
    }
  }
}
