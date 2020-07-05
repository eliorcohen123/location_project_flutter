import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofence/geofence.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locationprojectflutter/data/models/model_googleapis/results.dart';
import 'package:locationprojectflutter/data/models/model_stream_location/user_location.dart';
import 'package:locationprojectflutter/data/repositories_impl/location_repo_impl.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/map_list_provider.dart';
import 'package:locationprojectflutter/presentation/utils/map_utils.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/widgets/appbar_total.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapList extends StatelessWidget {
  final double latList, lngList;
  final String nameList, vicinityList;

  MapList({
    Key key,
    this.latList,
    this.lngList,
    this.nameList,
    this.vicinityList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MapListProvider>(
      builder: (context, results, child) {
        return MapListProv(
          latList: latList,
          lngList: lngList,
          nameList: nameList,
          vicinityList: vicinityList,
        );
      },
    );
  }
}

class MapListProv extends StatefulWidget {
  final double latList, lngList;
  final String nameList, vicinityList;

  MapListProv(
      {Key key, this.nameList, this.vicinityList, this.latList, this.lngList})
      : super(key: key);

  @override
  _MapListProvState createState() => _MapListProvState();
}

class _MapListProvState extends State<MapListProv> {
  MapCreatedCallback _onMapCreated;
  double _valueRadius, _valueGeofence;
  String _open;
  bool _zoomGesturesEnabled = true;
  List<Results> _places = List();
  var _userLocation, _provider;
  LocationRepoImpl _locationRepoImpl = LocationRepoImpl();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<MapListProvider>(context, listen: false);
      _provider.isSearch(false);
      _initMarker();
    });

    _initGetSharedPrefs();
    _initGeofence();
    _initPlatformState();
    _initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    _userLocation = Provider.of<UserLocation>(context);
    var _currentLocation =
        LatLng(_userLocation.latitude, _userLocation.longitude);
    return Scaffold(
      appBar: AppBarTotal(),
      body: Container(
        child: Center(
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
                circles: Set.from([
                  Circle(
                    circleId: CircleId(
                      _currentLocation.toString(),
                    ),
                    center: _currentLocation,
                    fillColor: Color(0x300000ff),
                    strokeColor: Color(0x300000ff),
                    radius: _valueRadius,
                  ),
                ]),
                mapType: MapType.normal,
              ),
              if (_provider.searchGet)
                Container(
                  decoration: BoxDecoration(
                    color: Color(0x80000000),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
            ],
          ),
        ),
      ),
      drawer: DrawerTotal(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _searchNearbyList();
        },
        label: Text('Show nearby places'),
        icon: Icon(Icons.place),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _initGetSharedPrefs() {
    SharedPreferences.getInstance().then(
      (prefs) {
        _provider.sharedPref(prefs);
        _valueRadius = _provider.sharedGet.getDouble('rangeRadius') ?? 5000.0;
        _valueGeofence =
            _provider.sharedGet.getDouble('rangeGeofence') ?? 500.0;
        _open = _provider.sharedGet.getString('open') ?? '';
      },
    );
  }

  void _initGeofence() {
    Geofence.requestPermissions();
    Geolocation location = Geolocation(
        latitude: widget.latList != null ? widget.latList : 0.0,
        longitude: widget.lngList != null ? widget.lngList : 0.0,
        radius: _valueGeofence,
        id: widget.nameList != null ? widget.nameList : 'id');
    Geofence.addGeolocation(location, GeolocationEvent.entry).then(
      (onValue) {
        print("great success");
      },
    ).catchError(
      (onError) {
        print("great failure");
      },
    );
  }

  void _initPlatformState() async {
    String namePlace = widget.nameList;
    Geofence.initialize();
    Geofence.startListening(
      GeolocationEvent.entry,
      (entry) {
        print("Entry to place");
        _showNotification(
            "Entry of a place",
            "Welcome to: $namePlace + in " +
                _valueGeofence.round().toString() +
                " Meters");
      },
    );
    Geofence.startListening(
      GeolocationEvent.exit,
      (entry) {
        print("Exit from place");
        _showNotification("Exit of a place", "Goodbye to: $namePlace");
      },
    );
  }

  void _initNotifications() {
    var android = AndroidInitializationSettings('assets/icon.png');
    var iOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(android, iOS);
    _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void _showNotification(String title, String subtitle) async {
    var android = AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max);
    var iOS = IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    await _flutterLocalNotificationsPlugin.show(0, title, subtitle, platform,
        payload: subtitle);
  }

  void _initMarker() {
    _provider.markersGet.add(
      Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        markerId: MarkerId(widget.nameList != null ? widget.nameList : ""),
        position: LatLng(widget.latList != null ? widget.latList : 0.0,
            widget.lngList != null ? widget.lngList : 0.0),
        onTap: () {
          String namePlace = widget.nameList != null ? widget.nameList : "";
          String vicinityPlace =
              widget.vicinityList != null ? widget.vicinityList : "";
          _showDialog(namePlace, vicinityPlace, widget.latList, widget.lngList);
        },
      ),
    );
  }

  void _searchNearbyList() async {
    _provider.isSearch(true);
    _provider.clearMarkers();
    _places = await _locationRepoImpl.getLocationJson(_userLocation.latitude,
        _userLocation.longitude, _open, '', _valueRadius.round(), '');
    for (int i = 0; i < _places.length; i++) {
      _provider.markersGet.add(
        Marker(
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          markerId: MarkerId(_places[i].name),
          position: LatLng(_places[i].geometry.location.lat,
              _places[i].geometry.location.lng),
          onTap: () {
            String namePlace = _places[i].name != null ? _places[i].name : "";
            String vicinityPlace =
                _places[i].vicinity != null ? _places[i].vicinity : "";
            _showDialog(
                namePlace,
                vicinityPlace,
                _places[i].geometry.location.lat,
                _places[i].geometry.location.lng);
          },
        ),
      );
    }
    _provider.isSearch(false);
  }

  Future _showDialog(
      String namePlace, String vicinity, double lat, double lng) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(
                child: Text(
                  '$namePlace',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: ResponsiveScreen().heightMediaQuery(context, 20),
              ),
              Text(
                "Would you want to navigate $namePlace?",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: ResponsiveScreen().heightMediaQuery(context, 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: ResponsiveScreen().heightMediaQuery(context, 40),
                    width: ResponsiveScreen().widthMediaQuery(context, 100),
                    child: RaisedButton(
                      highlightElevation: 0.0,
                      splashColor: Colors.deepPurpleAccent,
                      highlightColor: Colors.deepPurpleAccent,
                      elevation: 0.0,
                      color: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        'No',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveScreen().widthMediaQuery(context, 20),
                  ),
                  Container(
                    height: ResponsiveScreen().heightMediaQuery(context, 40),
                    width: ResponsiveScreen().widthMediaQuery(context, 100),
                    child: RaisedButton(
                      highlightElevation: 0.0,
                      splashColor: Colors.deepPurpleAccent,
                      highlightColor: Colors.deepPurpleAccent,
                      elevation: 0.0,
                      color: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      onPressed: () {
                        MapUtils()
                            .openMaps(context, namePlace, vicinity, lat, lng);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
