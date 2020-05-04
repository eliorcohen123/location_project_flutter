import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:latlong/latlong.dart' as dis;
import 'package:locationprojectflutter/core/constants/constants.dart';
import 'package:locationprojectflutter/data/models/error.dart';
import 'package:locationprojectflutter/data/models/place_response.dart';
import 'package:locationprojectflutter/data/models/result.dart';
import 'package:locationprojectflutter/presentation/others/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/pages/add_data_favorites_activity.dart';
import 'package:locationprojectflutter/presentation/pages/map_list_activity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class ListMap extends StatefulWidget {
  ListMap({Key key}) : super(key: key);

  @override
  _ListMapState createState() => _ListMapState();
}

class _ListMapState extends State<ListMap> {
  Error _error;
  List<Result> _places;
  bool _searching = true;
  int _valueRadiusText;
  double _valueRadius;
  SharedPreferences _sharedPrefs;
  Position _currentPosition;

  @override
  void initState() {
    super.initState();

    _getLocationPermission();
    _getCurrentLocation();
    _initGetSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    _searchNearby(
        _currentPosition.latitude, _currentPosition.longitude, _valueRadius);
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.separated(
                  itemCount: _places.length,
                  itemBuilder: (BuildContext context, int index) {
                    final dis.Distance _distance = new dis.Distance();
                    final double _meter = _distance(
                        new dis.LatLng(_currentPosition.latitude,
                            _currentPosition.longitude),
                        new dis.LatLng(_places[index].geometry.location.lat,
                            _places[index].geometry.location.long));
                    return GestureDetector(
                      child: Container(
                        color: Color(0xff4682B4),
                        child: Column(
                          children: <Widget>[
                            Text(_places[index].name,
                                style: TextStyle(
                                    fontSize: 17, color: Color(0xffE9FFFF))),
                            Text(_places[index].vicinity,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white)),
                            Text(_calculateDistance(_meter),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white)),
                          ],
                        ),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapListActivity(
                              nameList: _places[index].name,
                              latList: _places[index].geometry.location.lat,
                              lngList: _places[index].geometry.location.long,
                            ),
                          )),
                      onLongPress: () => _showDialogList(index),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                        height: ResponsiveScreen().heightMediaQuery(context, 2),
                        decoration:
                            new BoxDecoration(color: Color(0xffdcdcdc)));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _initGetSharedPref() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() => _sharedPrefs = prefs);
      _valueRadius = prefs.getDouble('rangeRadius') ?? 5000.0;
    });
  }

  _calculateDistance(double _meter) {
    String _myMeters;
    if (_meter < 1000.0) {
      _myMeters = 'Meters: ' + (_meter.round()).toString();
    } else {
      _myMeters =
          'KM: ' + (_meter.round() / 1000.0).toStringAsFixed(2).toString();
    }
    return _myMeters;
  }

  _showDialogList(int index) async {
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        actions: <Widget>[
          FlatButton(
            child: Text("Add to favorites"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddDataFavoritesActivity(
                      nameList: _places[index].name,
                      latList: _places[index].geometry.location.lat,
                      lngList: _places[index].geometry.location.long,
                      addressList: _places[index].vicinity,
                    ),
                  ));
            },
          ),
          FlatButton(
            child: Text("Share"),
          ),
        ],
      ),
    );
  }

  _getLocationPermission() async {
    var location = new loc.Location();
    try {
      location.requestPermission();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  _searchNearby(double latitude, double longitude, double radius) async {
    _valueRadiusText = radius.round();
    String _baseUrl = Constants.baseUrl;
    String _API_KEY = Constants.API_KEY;
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

  _handleResponse(data) {
    if (data['status'] == "REQUEST_DENIED") {
      setState(() {
        _error = Error.fromJson(data);
      });
    } else if (data['status'] == "OK") {
      setState(() {
        _places = PlaceResponse.parseResults(data['results']);
      });
    } else {
      print(data);
    }
  }

  _getCurrentLocation() {
    final Geolocator _geoLocator = Geolocator()..forceAndroidLocationManager;
    _geoLocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }
}
