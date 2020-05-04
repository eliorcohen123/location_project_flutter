import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:locationprojectflutter/presentation/pages/add_data_favorites.dart';
import 'package:locationprojectflutter/presentation/pages/favorites_data.dart';
import 'package:locationprojectflutter/presentation/pages/slider_activity.dart';

class FavoritesDataActivity extends StatelessWidget {
  FavoritesDataActivity({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Lovely Favorite Places'),
      ),
      body: FavoritesData(),
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
                      builder: (context) => SliderActivity(),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
