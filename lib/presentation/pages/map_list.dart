import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locationprojectflutter/data/models/error.dart';
import 'package:locationprojectflutter/data/models/place_response.dart';
import 'package:locationprojectflutter/data/models/result.dart';
import 'package:locationprojectflutter/data/models/user_location.dart';
import 'package:locationprojectflutter/presentation/others/map_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart' as geo;

class MapList extends StatefulWidget {
  final double latList, lngList;
  final String nameList;

  MapList({Key key, this.nameList, this.latList, this.lngList})
      : super(key: key);

  @override
  _MapListState createState() => _MapListState();
}

class _MapListState extends State<MapList> {
  GoogleMapController _myMapController;
  Set<Circle> _circles;
  SharedPreferences _sharedPrefs;
  double _valueRadius;
  int _valueRadiusText;
  bool _zoomGesturesEnabled = true, _searching = true;
  static const String _API_KEY = 'AIzaSyCiH1NZGzqJE2T_X5CphQD3iazzrjJbL4A';
  static const String _baseUrl =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json";
  List<Marker> _markers = <Marker>[];
  List<Result> _places;
  Error _error;
  Position _currentPosition;

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
    _initGetSharedPref();
    _initMarkerList();
  }

  @override
  Widget build(BuildContext context) {
    var _userLocation = Provider.of<UserLocation>(context);
    var _currentLocation =
        LatLng(_userLocation.latitude, _userLocation.longitude);
    return MaterialApp(
        home: Scaffold(
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
        circles: _circles = Set.from([
          Circle(
            circleId: CircleId(
                LatLng(_currentPosition.latitude, _currentPosition.longitude)
                    .toString()),
            center:
                LatLng(_currentPosition.latitude, _currentPosition.longitude),
            fillColor: Color(0x300000ff),
            strokeColor: Color(0x300000ff),
            radius: _valueRadius,
          )
        ]),
        mapType: MapType.normal,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _searchNearby(_currentPosition.latitude, _currentPosition.longitude,
              _valueRadius);
        },
        label: Text('Show nearby places'),
        icon: Icon(Icons.place),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    ));
  }

  _initGetSharedPref() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() => _sharedPrefs = prefs);
      _valueRadius = prefs.getDouble('rangeRadius') ?? 5000.0;
    });
  }

  _initMarkerList() {
    _markers.add(Marker(
      markerId: MarkerId(widget.nameList != null ? widget.nameList : ""),
      position: LatLng(widget.latList != null ? widget.latList : 0.0,
          widget.lngList != null ? widget.lngList : 0.0),
      onTap: () {
        String namePlace = widget.nameList != null ? widget.nameList : "";
        showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text(namePlace),
            content: new Text("האם תרצה לנווט ל$namePlace"),
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
                  MapUtils.openMap(widget.latList, widget.lngList);
                },
              ),
            ],
          ),
        );
      },
    ));
  }

  _searchNearby(double latitude, double longitude, double radius) async {
    _valueRadiusText = radius.round();
    setState(() {
      _markers.clear();
    });
    String url =
        '$_baseUrl?key=$_API_KEY&location=$latitude,$longitude&opennow=true&radius=$_valueRadiusText&keyword=';
    print(url);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _handleResponse(data);
    } else {
      throw Exception('An error occurred getting places nearby');
    }
    setState(() {
      _searching = false;
    });
  }

  _getCurrentLocation() {
    final Geolocator _geoLocator = Geolocator()..forceAndroidLocationManager;
    _geoLocator
        .getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  _handleResponse(data) {
    if (data['status'] == "REQUEST_DENIED") {
      setState(() {
        _error = Error.fromJson(data);
      });
    } else if (data['status'] == "OK") {
      setState(() {
        _places = PlaceResponse.parseResults(data['results']);
        for (int i = 0; i < _places.length; i++) {
          _markers.add(
            Marker(
              markerId: MarkerId(_places[i].name),
              position: LatLng(_places[i].geometry.location.lat,
                  _places[i].geometry.location.long),
              onTap: () {
                String namePlace = _places[i].name;
                showDialog(
                  context: context,
                  builder: (_) => new AlertDialog(
                    title: new Text(namePlace),
                    content: new Text("האם תרצה לנווט ל$namePlace"),
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
                          MapUtils.openMap(_places[i].geometry.location.lat,
                              _places[i].geometry.location.long);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
      });
    } else {
      print(data);
    }
  }
}
