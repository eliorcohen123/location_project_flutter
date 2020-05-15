import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:locationprojectflutter/data/models/model_location/result.dart';
import 'package:locationprojectflutter/data/models/model_stream_location/user_location.dart';
import 'package:locationprojectflutter/domain/usecases_domain/get_location_json_usecase.dart';
import 'package:locationprojectflutter/presentation/utils/map_utils.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String _open;
  bool _zoomGesturesEnabled = true, _searching = true;
  List<Marker> _markers = <Marker>[];
  List<Result> _places;
  var _userLocation;
  GetLocationJsonUsecase _getLocationJsonUsecase = GetLocationJsonUsecase();

  @override
  void initState() {
    super.initState();

    _initGetSharedPref();
    _initMarker();
  }

  @override
  Widget build(BuildContext context) {
    _userLocation = Provider.of<UserLocation>(context);
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
        circles: _circles = Set.from([
          Circle(
            circleId: CircleId(
                LatLng(_userLocation.latitude, _userLocation.longitude)
                    .toString()),
            center: LatLng(_userLocation.latitude, _userLocation.longitude),
            fillColor: Color(0x300000ff),
            strokeColor: Color(0x300000ff),
            radius: _valueRadius,
          )
        ]),
        mapType: MapType.normal,
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

  _initGetSharedPref() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() => _sharedPrefs = prefs);
      _valueRadius = prefs.getDouble('rangeRadius') ?? 5000.0;
      _open = prefs.getString('open') ?? '';
    });
  }

  _searchNearbyList() async {
    setState(() {
      _markers.clear();
    });
    _places = await _getLocationJsonUsecase.callLocation(
        paramsLocation: ParamsLocation(
            latitude: _userLocation.latitude,
            longitude: _userLocation.longitude,
            open: _open,
            type: '',
            valueRadiusText: _valueRadius.round(),
            text: ''));
    setState(() {
      for (int i = 0; i < _places.length; i++) {
        _markers.add(
          Marker(
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet),
            markerId: MarkerId(_places[i].name),
            position: LatLng(_places[i].geometry.location.lat,
                _places[i].geometry.location.long),
            onTap: () {
              String namePlace = _places[i].name != null ? _places[i].name : "";
              _showDialog(namePlace, _places[i].geometry.location.lat,
                  _places[i].geometry.location.long);
            },
          ),
        );
      }
      _searching = false;
      print(_searching);
    });
  }

  _initMarker() {
    _markers.add(Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      markerId: MarkerId(widget.nameList != null ? widget.nameList : ""),
      position: LatLng(widget.latList != null ? widget.latList : 0.0,
          widget.lngList != null ? widget.lngList : 0.0),
      onTap: () {
        String namePlace = widget.nameList != null ? widget.nameList : "";
        _showDialog(namePlace, widget.latList, widget.lngList);
      },
    ));
  }

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
