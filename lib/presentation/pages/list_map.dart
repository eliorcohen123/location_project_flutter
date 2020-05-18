import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:location/location.dart' as loc;
import 'package:latlong/latlong.dart' as dis;
import 'package:locationprojectflutter/core/constants/constant.dart';
import 'package:locationprojectflutter/data/models/model_location/result.dart';
import 'package:locationprojectflutter/data/models/model_stream_location/user_location.dart';
import 'package:locationprojectflutter/data/repositories_impl/location_repo_impl.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:locationprojectflutter/presentation/widgets/responsive_screen.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'add_or_edit_data_favorites.dart';
import 'map_list.dart';

class ListMap extends StatefulWidget {
  ListMap({Key key}) : super(key: key);

  @override
  _ListMapState createState() => _ListMapState();
}

class _ListMapState extends State<ListMap> {
  List<Result> _places = List();
  bool _searching = true, _activeSearch = false;
  double _valueRadius;
  String _open;
  SharedPreferences _sharedPrefs;
  var _userLocation;
  String _API_KEY = Constants.API_KEY;
  LocationRepoImpl _locationRepoImpl = LocationRepoImpl();
  final _formKeySearch = GlobalKey<FormState>();
  final controllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();

    _getLocationPermission();
    _initGetSharedPref();
  }

  PreferredSizeWidget _appBar() {
    if (_activeSearch) {
      return AppBar(
        backgroundColor: Color(0xFF1E2538),
        title: Form(
          key: _formKeySearch,
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search a place...',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white,
                          width: 1.0,
                          style: BorderStyle.solid),
                    ),
                  ),
                  controller: controllerSearch,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                color: Color(0xFFE9FFFF),
                onPressed: () {
                  if (_formKeySearch.currentState.validate()) {
                    _searchNearby(true, "", controllerSearch.text);
                  }
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            color: Color(0xFFE9FFFF),
            onPressed: () => setState(() => _activeSearch = false),
          )
        ],
      );
    } else {
      return AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Lovely Favorite Places',
          style: TextStyle(color: Color(0xFFE9FFFF)),
        ),
        iconTheme: IconThemeData(color: Color(0xFFE9FFFF)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Color(0xFFE9FFFF),
            onPressed: () => setState(() => _activeSearch = true),
          ),
          IconButton(
            icon: Icon(Icons.navigation),
            color: Color(0xFFE9FFFF),
            onPressed: () => _searchNearby(true, "", ""),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _userLocation = Provider.of<UserLocation>(context);
    _searchNearby(_searching, "", "");
    return Scaffold(
        appBar: _appBar(),
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
                        child: LiveList(
                          showItemInterval: Duration(milliseconds: 50),
                          showItemDuration: Duration(milliseconds: 50),
                          reAnimateOnVisibility: true,
                          scrollDirection: Axis.vertical,
                          itemCount: _places.length,
                          itemBuilder: buildAnimatedItem,
                        ),
                      ),
              ],
            ),
          ),
        ),
        drawer: DrawerTotal());
  }

  Widget buildAnimatedItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) =>
      FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animation),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, -0.1),
            end: Offset.zero,
          ).animate(animation),
          child: _childLiveList(index),
        ),
      );

  _childLiveList(int index) {
    final dis.Distance _distance = dis.Distance();
    final double _meter = _distance(
        dis.LatLng(_userLocation.latitude, _userLocation.longitude),
        dis.LatLng(_places[index].geometry.location.lat,
            _places[index].geometry.location.long));
    return Slidable(
      key: UniqueKey(),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.10,
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.green,
          icon: Icons.add,
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddOrEditDataFavorites(
                    nameList: _places[index].name,
                    addressList: _places[index].vicinity,
                    latList: _places[index].geometry.location.lat,
                    lngList: _places[index].geometry.location.long,
                    photoList: _places[index].photos.isNotEmpty
                        ? _places[index].photos[0].photoReference
                        : "",
                    edit: false,
                  ),
                ))
          },
        ),
        IconSlideAction(
          color: Colors.greenAccent,
          icon: Icons.directions,
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapList(
                    nameList: _places[index].name,
                    latList: _places[index].geometry.location.lat,
                    lngList: _places[index].geometry.location.long,
                  ),
                ))
          },
        ),
        IconSlideAction(
          color: Colors.blueGrey,
          icon: Icons.share,
          onTap: () => {
            _shareContent(
                _places[index].name,
                _places[index].vicinity,
                _places[index].geometry.location.lat,
                _places[index].geometry.location.long,
                _places[index].photos[0].photoReference)
          },
        ),
      ],
      child: GestureDetector(
        child: Container(
          color: Colors.grey,
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: ResponsiveScreen().heightMediaQuery(context, 5),
                    width: double.infinity,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(color: Colors.white),
                    ),
                  ),
                  CachedNetworkImage(
                    fit: BoxFit.fill,
                    height: ResponsiveScreen().heightMediaQuery(context, 150),
                    width: double.infinity,
                    imageUrl: _places[index].photos.isNotEmpty
                        ? "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" +
                            _places[index].photos[0].photoReference +
                            "&key=$_API_KEY"
                        : "https://upload.wikimedia.org/wikipedia/commons/7/75/No_image_available.png",
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  SizedBox(
                    height: ResponsiveScreen().heightMediaQuery(context, 5),
                    width: double.infinity,
                    child: const DecoratedBox(
                      decoration: const BoxDecoration(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Container(
                height: ResponsiveScreen().heightMediaQuery(context, 160),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xAA000000),
                      const Color(0x00000000),
                      const Color(0x00000000),
                      const Color(0xAA000000),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _textList(_places[index].name, 17.0, 0xffE9FFFF),
                    _textList(_places[index].vicinity, 15.0, 0xFFFFFFFF),
                    _textList(_calculateDistance(_meter), 15.0, 0xFFFFFFFF),
                  ],
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
      _open = prefs.getString('open') ?? '';
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
          onPressed: () => _searchNearby(true, type, ""),
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

  _textList(String text, double fontSize, int color) {
    return Text(text,
        style: TextStyle(shadows: <Shadow>[
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 1.0,
            color: Color(0xAA000000),
          ),
        ], fontSize: fontSize, color: Color(color)));
  }

  _getLocationPermission() async {
    var location = loc.Location();
    try {
      location.requestPermission();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission denied');
      }
    }
  }

  Future _searchNearby(bool search, String type, String text) async {
    if (search) {
      _places = await _locationRepoImpl.getLocationJson(_userLocation.latitude,
          _userLocation.longitude, _open, type, _valueRadius.round(), text);
      setState(() {
        _searching = false;
        _places.sort((a, b) => sqrt(
                pow(a.geometry.location.lat - _userLocation.latitude, 2) +
                    pow(a.geometry.location.long - _userLocation.longitude, 2))
            .compareTo(sqrt(pow(
                    b.geometry.location.lat - _userLocation.latitude, 2) +
                pow(b.geometry.location.long - _userLocation.longitude, 2))));
        print(_searching);
      });
    }
  }

  _shareContent(
      String name, String vicinity, double lat, double lng, String photo) {
    final RenderBox box = context.findRenderObject();
    Share.share(
        'Name: $name' +
            '\n' +
            'Vicinity: $vicinity' +
            '\n' +
            'Latitude: $lat' +
            '\n' +
            'Longitude: $lng' +
            '\n' +
            'Photo: $photo',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}
