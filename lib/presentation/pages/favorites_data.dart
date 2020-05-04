import 'package:flutter/material.dart';
import 'package:locationprojectflutter/data/database/sqflite_helper.dart';
import 'package:locationprojectflutter/data/models/result.dart';
import 'package:locationprojectflutter/presentation/others/responsive_screen.dart';

class FavoritesData extends StatefulWidget {
  const FavoritesData({Key key}) : super(key: key);

  @override
  _FavoritesDataState createState() => _FavoritesDataState();
}

class _FavoritesDataState extends State<FavoritesData> {
  List<Result> _places = new List();
  SQFLiteHelper db = new SQFLiteHelper();

  @override
  void initState() {
    super.initState();

    _getItems();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
          Expanded(
            child: ListView.separated(
              itemCount: _places.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Container(
                    color: Color(0xff4682B4),
                    child: Column(
                      children: <Widget>[
                        Text(_places[index].name,
                            style: TextStyle(
                                fontSize: 17, color: Color(0xffE9FFFF))),
                        Text(_places[index].vicinity,
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
//                        Text(_calculateDistance(_meter),
//                            style:
//                                TextStyle(fontSize: 15, color: Colors.white)),
                      ],
                    ),
                  ),
//                  onTap: () => Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => MapListActivity(
//                          nameList: _places[index].name,
//                          latList: _places[index].geometry.location.lat,
//                          lngList: _places[index].geometry.location.long,
//                        ),
//                      )),
//                  onLongPress: () => _showDialogList(index),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                    height: ResponsiveScreen().heightMediaQuery(context, 2),
                    decoration: new BoxDecoration(color: Color(0xffdcdcdc)));
              },
            ),
          ),
        ]))));
  }

  void _getItems() async {
    db.getAllResults().then((results) {
      setState(() {
        _places.clear();
        results.forEach((result) {
          _places.add(Result.fromSqlf(result));
        });
      });
    });
  }
}
