import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locationprojectflutter/presentation/pages/map_list.dart';
import 'package:locationprojectflutter/presentation/pages/slider_location_activity.dart';

class MapListActivity extends StatelessWidget {
  final double latList, lngList;
  final String nameList;

  MapListActivity({Key key, this.nameList, this.latList, this.lngList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Lovely Favorite Places'),
      ),
      body: MapList(
        nameList: nameList,
        latList: latList,
        lngList: lngList,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Hello user!',
                style: TextStyle(color: Colors.yellowAccent, fontSize: 20),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Text(
                'Credits',
                style: TextStyle(color: Colors.yellowAccent),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'List settings',
                style: TextStyle(color: Colors.yellowAccent),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SliderLocationActivity(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
