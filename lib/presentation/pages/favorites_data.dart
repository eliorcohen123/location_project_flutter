import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:locationprojectflutter/core/constants/constant.dart';
import 'package:locationprojectflutter/data/models/model_sqfl/result_sqfl.dart';
import 'package:locationprojectflutter/data/models/model_stream_location/user_location.dart';
import 'package:locationprojectflutter/presentation/pages/add_or_edit_data_favorites.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/results_sqfl_provider.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:latlong/latlong.dart' as dis;
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'map_list.dart';

//import 'package:locationprojectflutter/presentation/state_management/mobx/results_sqfl_mobx.dart';
//import 'package:mobx/mobx.dart';

class FavoritesData extends StatefulWidget {
  const FavoritesData({Key key}) : super(key: key);

  @override
  _FavoritesDataState createState() => _FavoritesDataState();
}

class _FavoritesDataState extends State<FavoritesData> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ResultsSqflProvider>(builder: (context, results, child) {
      return FavoritesDataProv();
    });
  }
}

class FavoritesDataProv extends StatefulWidget {
  const FavoritesDataProv({Key key}) : super(key: key);

  @override
  _FavoritesDataProvState createState() => _FavoritesDataProvState();
}

class _FavoritesDataProvState extends State<FavoritesDataProv> {
  var _userLocation, _sqflProv;
  String _API_KEY = Constants.API_KEY;

//  ObservableList<ResultSqfl> _places = ObservableList.of([]); // MobX
//  final ResultsSqflStore _sqflMobx = ResultsSqflStore(); // MobX
  List<ResultSqfl> _places = List();

  @override
  void initState() {
    super.initState();

    _sqflProv =
        Provider.of<ResultsSqflProvider>(context, listen: false); // Provider
    _sqflProv.initList(_places); // Provider
    _sqflProv.getItems(); // Provider

//    _sqflMobx.initList(_places); // MobX
//    _sqflMobx.getItems(); // MobX
  }

  @override
  Widget build(BuildContext context) {
    _userLocation = Provider.of<UserLocation>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Lovely Favorite Places',
            style: TextStyle(color: Color(0xFFE9FFFF)),
          ),
          iconTheme: IconThemeData(color: Color(0xFFE9FFFF)),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete_forever),
              color: Color(0xFFE9FFFF),
              onPressed: () => _sqflProv.deleteData(), // Provider
//              onPressed: () => _sqflMobx.deleteData(), // MobX
            )
          ],
        ),
        body: Center(
            child: Column(children: <Widget>[
          Expanded(
//              child: Observer(builder: (_) { // MobX
            child: LiveList(
              showItemInterval: Duration(milliseconds: 50),
              showItemDuration: Duration(milliseconds: 50),
              reAnimateOnVisibility: true,
              scrollDirection: Axis.vertical,
              itemCount: _places.length,
              itemBuilder: buildAnimatedItem,
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                    height: ResponsiveScreen().heightMediaQuery(context, 10),
                    decoration: BoxDecoration(color: Colors.grey));
              },
            ),
//              }),
          ),
        ])),
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
        dis.LatLng(_places[index].lat, _places[index].lng));
    return Slidable(
      key: UniqueKey(),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.10,
      secondaryActions: <Widget>[
        IconSlideAction(
          color: Colors.orange,
          icon: Icons.edit,
          onTap: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddOrEditDataFavorites(
                    id: _places[index].id,
                    nameList: _places[index].name,
                    addressList: _places[index].vicinity,
                    latList: _places[index].lat,
                    lngList: _places[index].lng,
                    photoList: _places[index].photo,
                    edit: true,
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
                    vicinityList: _places[index].vicinity,
                    latList: _places[index].lat,
                    lngList: _places[index].lng,
                  ),
                ))
          },
        ),
        IconSlideAction(
          color: Colors.blueGrey,
          icon: Icons.share,
          onTap: () => {
            _shareContent(_places[index].name, _places[index].vicinity,
                _places[index].lat, _places[index].lng, _places[index].photo)
          },
        ),
      ],
      actions: [
        IconSlideAction(
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => {
            _sqflProv.deleteItem(_places[index], index) // Provider
//                            _sqflMobx.deleteItem(_places[index], index); // Mobx
          },
        ),
      ],
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        dismissThresholds: <SlideActionType, double>{
          SlideActionType.secondary: 1.0
        },
        onDismissed: (actionType) {
          _sqflProv.deleteItem(_places[index], index); // Provider
//                            _sqflMobx.deleteItem(_places[index], index); // Mobx
        },
      ),
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
                    imageUrl: _places[index].photo.isNotEmpty
                        ? "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=" +
                            _places[index].photo +
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

  _textList(String text, double fontSize, int color) {
    return Text(text,
        style: TextStyle(shadows: <Shadow>[
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 1.0,
            color: Color(0xAA000000),
          ),
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 1.0,
            color: Color(0xAA000000),
          ),
        ], fontSize: fontSize, color: Color(color)));
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
