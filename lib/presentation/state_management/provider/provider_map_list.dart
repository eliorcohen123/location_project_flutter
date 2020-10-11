import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_geofence/geofence.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locationprojectflutter/data/models/model_googleapis/results.dart';
import 'package:locationprojectflutter/data/models/model_stream_location/user_location.dart';
import 'package:locationprojectflutter/data/repositories_impl/location_repo_impl.dart';
import 'package:locationprojectflutter/presentation/utils/map_utils.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/utils/utils_app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderMapList extends ChangeNotifier {
  final LocationRepoImpl _locationRepoImpl = LocationRepoImpl();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  SharedPreferences _sharedPrefs;
  List<Marker> _markers = [];
  bool _isSearching = false;
  MapCreatedCallback _onMapCreated;
  double _valueRadius, _valueGeofence;
  String _open;
  List<Results> _places = [];
  UserLocation _userLocation;
  LatLng _currentLocation;

  SharedPreferences get sharedGet => _sharedPrefs;

  List<Marker> get markersGet => _markers;

  bool get isSearchingGet => _isSearching;

  MapCreatedCallback get onMapCreatedGet => _onMapCreated;

  UserLocation get userLocationGet => _userLocation;

  LatLng get currentLocationGet => _currentLocation;

  double get valueRadiusGet => _valueRadius;

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }

  void clearMarkers() {
    _markers.clear();
    notifyListeners();
  }

  void isSearching(bool isSearching) {
    _isSearching = isSearching;
    notifyListeners();
  }

  void userLocation(BuildContext context) {
    _userLocation = Provider.of<UserLocation>(context);
  }

  void currentLocation() {
    _currentLocation = LatLng(_userLocation.latitude, _userLocation.longitude);
  }

  Future _showDialog(String namePlace, String vicinity, double lat, double lng,
      BuildContext context) {
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
                  namePlace,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              UtilsApp.dividerHeight(context, 20),
              Text(
                "Would you want to navigate to $namePlace?",
                textAlign: TextAlign.center,
              ),
              UtilsApp.dividerHeight(context, 20),
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
                      child: const Text(
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
                  UtilsApp.dividerWidth(context, 20),
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
                      child: const Text(
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

  void initGetSharedPrefs() {
    SharedPreferences.getInstance().then(
      (prefs) {
        sharedPref(prefs);
        _valueRadius = sharedGet.getDouble('rangeRadius') ?? 5000.0;
        _valueGeofence = sharedGet.getDouble('rangeGeofence') ?? 500.0;
        _open = sharedGet.getString('open') ?? '';
      },
    );
  }

  void initGeofence(double latList, double lngList, String nameList) {
    Geofence.requestPermissions();
    Geolocation location = Geolocation(
        latitude: latList != null ? latList : 0.0,
        longitude: lngList != null ? lngList : 0.0,
        radius: _valueGeofence,
        id: nameList != null ? nameList : 'id');
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

  void initPlatformState(String nameList) async {
    Geofence.initialize();
    Geofence.startListening(
      GeolocationEvent.entry,
      (entry) {
        print("Entry to place");
        _showNotification(
            "Entry of a place",
            "Welcome to: $nameList + in " +
                _valueGeofence.round().toString() +
                " Meters");
      },
    );
    Geofence.startListening(
      GeolocationEvent.exit,
      (entry) {
        print("Exit from place");
        _showNotification("Exit of a place", "Goodbye to: $nameList");
      },
    );
  }

  void initNotifications() {
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = const IOSInitializationSettings();
    var initSettings = InitializationSettings(android, iOS);
    _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void _showNotification(String title, String subtitle) async {
    var android = AndroidNotificationDetails(
      'com.eliorcohen.locationprojectflutter',
      'Lovely Favorite Places',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android, iOS);
    await _flutterLocalNotificationsPlugin.show(0, title, subtitle, platform,
        payload: subtitle);
  }

  void initMarker(String nameList, String vicinityList, double latList,
      double lngList, BuildContext context) {
    clearMarkers();
    markersGet.add(
      Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        markerId: MarkerId(nameList != null ? nameList : ""),
        position: LatLng(
            latList != null ? latList : 0.0, lngList != null ? lngList : 0.0),
        onTap: () {
          String namePlace = nameList != null ? nameList : "";
          String vicinityPlace = vicinityList != null ? vicinityList : "";
          _showDialog(namePlace, vicinityPlace, latList, lngList, context);
        },
      ),
    );
  }

  void searchNearbyList(BuildContext context) async {
    clearMarkers();
    isSearching(true);
    _places = await _locationRepoImpl.getLocationJson(_userLocation.latitude,
        _userLocation.longitude, _open, '', _valueRadius.round(), '');
    for (int i = 0; i < _places.length; i++) {
      markersGet.add(
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
              _places[i].geometry.location.lng,
              context,
            );
          },
        ),
      );
    }
    isSearching(false);
  }
}
