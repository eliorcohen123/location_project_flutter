import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofence/geofence.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locationprojectflutter/data/models/model_googleapis/results.dart';
import 'package:locationprojectflutter/data/models/model_stream_location/user_location.dart';
import 'package:locationprojectflutter/data/repositories_impl/location_repo_impl.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/provider_map_list.dart';
import 'package:locationprojectflutter/presentation/utils/map_utils.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/utils/utils_app.dart';
import 'package:locationprojectflutter/presentation/widgets/widget_app_bar_total.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:locationprojectflutter/core/constants/constants_colors.dart';

class PageMapList extends StatelessWidget {
  final double latList, lngList;
  final String nameList, vicinityList;

  const PageMapList(
      {Key key,
      @required this.latList,
      @required this.lngList,
      @required this.nameList,
      @required this.vicinityList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderMapList>(
      builder: (context, results, child) {
        return PageMapListProv(
          latList: latList,
          lngList: lngList,
          nameList: nameList,
          vicinityList: vicinityList,
        );
      },
    );
  }
}

class PageMapListProv extends StatefulWidget {
  final double latList, lngList;
  final String nameList, vicinityList;

  const PageMapListProv(
      {Key key, this.nameList, this.vicinityList, this.latList, this.lngList})
      : super(key: key);

  @override
  _PageMapListProvState createState() => _PageMapListProvState();
}

class _PageMapListProvState extends State<PageMapListProv> {
  final LocationRepoImpl _locationRepoImpl = LocationRepoImpl();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  MapCreatedCallback _onMapCreated;
  double _valueRadius, _valueGeofence;
  String _open;
  List<Results> _places = [];
  UserLocation _userLocation;
  ProviderMapList _provider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider = Provider.of<ProviderMapList>(context, listen: false);
      _provider.isSearching(false);
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
    LatLng _currentLocation =
        LatLng(_userLocation.latitude, _userLocation.longitude);
    return Scaffold(
      appBar: WidgetAppBarTotal(),
      body: Stack(
        children: [
          _googleMap(_currentLocation),
          if (_provider.isSearchingGet) _loading(),
        ],
      ),
      floatingActionButton: _floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _googleMap(LatLng _currentLocation) {
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
      circles: Set.from([
        Circle(
          circleId: CircleId(
            _currentLocation.toString(),
          ),
          center: _currentLocation,
          fillColor: ConstantsColors.LIGHT_PURPLE,
          strokeColor: ConstantsColors.LIGHT_PURPLE,
          radius: _valueRadius,
        ),
      ]),
      mapType: MapType.normal,
    );
  }

  Widget _loading() {
    return Container(
      decoration: BoxDecoration(
        color: ConstantsColors.DARK_GRAY2,
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        _searchNearbyList();
      },
      label: const Text('Show Nearby Places'),
      icon: const Icon(Icons.place),
    );
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

  void _initMarker() {
    _provider.clearMarkers();
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
    _provider.clearMarkers();
    _provider.isSearching(true);
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
    _provider.isSearching(false);
  }
}
