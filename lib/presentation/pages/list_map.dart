import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:latlong/latlong.dart' as dis;
import 'package:locationprojectflutter/core/constants/constants.dart';
import 'package:locationprojectflutter/data/models/error.dart';
import 'package:locationprojectflutter/data/models/place_response.dart';
import 'package:locationprojectflutter/data/models/result.dart';
import 'package:locationprojectflutter/data/models/user_location.dart';
import 'package:locationprojectflutter/presentation/others/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/pages/add_data_favorites_activity.dart';
import 'package:locationprojectflutter/presentation/pages/map_list_activity.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:math';

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
  var _userLocation;

  @override
  void initState() {
    super.initState();

    _getLocationPermission();
    _initGetSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    _userLocation = Provider.of<UserLocation>(context);
    _searchNearby(_searching, "");
    _places.sort((a, b) => sqrt(pow(a.geometry.location.lat - _userLocation.latitude, 2) + pow(a.geometry.location.long - _userLocation.longitude, 2))
        .compareTo(sqrt(pow(b.geometry.location.lat - _userLocation.latitude, 2) + pow(b.geometry.location.long  - _userLocation.longitude, 2))));
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    _btnType('Banks', 'bank'),
                    _btnType('Bars', 'bar|night_club'),
                    _btnType('Beauty', 'beauty_salon|hair_care'),
                    _btnType('Books', 'book_store|library'),
                    _btnType('Bus stations', 'bus_station'),
                    _btnType(
                        'Cars', 'car_dealer|car_rental|car_repair|car_wash'),
                    _btnType('Clothing', 'clothing_store'),
                    _btnType('Doctors', 'doctor'),
                    _btnType('Gas stations', 'gas_station'),
                    _btnType('Gym', 'gym'),
                    _btnType('Jewelries', 'jewelry_store'),
                    _btnType('Parks', 'park|amusement_park|parking|rv_park'),
                    _btnType('Restaurants', 'food|restaurant|cafe|bakery'),
                    _btnType('School', 'school'),
                    _btnType('Spa', 'spa'),
                  ],
                ),
              ),
              _searching
                  ? CircularProgressIndicator()
                  : Expanded(
                      child: ListView.separated(
                        itemCount: _places.length,
                        itemBuilder: (BuildContext context, int index) {
                         final dis.Distance _distance = new dis.Distance();
                          final double _meter = _distance(
                              new dis.LatLng(_userLocation.latitude,
                                  _userLocation.longitude),
                              new dis.LatLng(
                                  _places[index].geometry.location.lat,
                                  _places[index].geometry.location.long));
                          return GestureDetector(
                            child: Container(
                              color: Color(0xff4682B4),
                              child: Column(
                                children: <Widget>[
                                  Text(_places[index].name,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xffE9FFFF))),
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
                                    latList:
                                        _places[index].geometry.location.lat,
                                    lngList:
                                        _places[index].geometry.location.long,
                                  ),
                                )),
                            onLongPress: () => _showDialogList(index),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                              height: ResponsiveScreen()
                                  .heightMediaQuery(context, 2),
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

  _btnType(String name, String type) {
    return Row(
      children: <Widget>[
        SizedBox(width: ResponsiveScreen().widthMediaQuery(context, 5)),
        RaisedButton(
          padding: EdgeInsets.all(0.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          onPressed: () => _searchNearby(_searching = true, type),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF5e7974),
                    Color(0xFF6494ED),
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(80.0))),
            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: Text(
              name,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(width: ResponsiveScreen().widthMediaQuery(context, 5)),
      ],
    );
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

  _searchNearby(bool search, String type) async {
    if (search) {
      _valueRadiusText = _valueRadius.round();
      String _baseUrl = Constants.baseUrl;
      String _API_KEY = Constants.API_KEY;
      double latitude = _userLocation.latitude;
      double longitude = _userLocation.longitude;
      String url =
          '$_baseUrl?key=$_API_KEY&location=$latitude,$longitude&opennow=true&types=$type&radius=$_valueRadiusText&keyword=';
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
        print(_searching);
      });
    }
  }

  _handleResponse(data) {
    if (data['status'] == "REQUEST_DENIED") {
      setState(() {
        _error = Error.fromJson(data);
        print(_error);
      });
    } else if (data['status'] == "OK") {
      setState(() {
        _places = PlaceResponse.parseResults(data['results']);
      });
    } else {
      print(data);
    }
  }
}
