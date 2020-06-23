import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:locationprojectflutter/presentation/pages/custom_map_list.dart';
import 'package:locationprojectflutter/presentation/pages/favorites_data.dart';
import 'package:locationprojectflutter/presentation/pages/home_chat.dart';
import 'package:locationprojectflutter/presentation/pages/list_map.dart';
import 'package:locationprojectflutter/presentation/pages/live_chat.dart';
import 'package:locationprojectflutter/presentation/pages/live_favorite_places.dart';
import 'package:locationprojectflutter/presentation/pages/signin_firebase.dart';
import 'package:locationprojectflutter/presentation/pages/settings_app.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';

class DrawerTotal extends StatelessWidget {
  static final DrawerTotal _singleton = DrawerTotal.internal();

  factory DrawerTotal() => _singleton;

  DrawerTotal.internal();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Color(0xFF1E2538),
      ),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: ResponsiveScreen().heightMediaQuery(context, 160),
              child: DrawerHeader(
                child: Center(
                  child: Text(
                    'Hello user!',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 40,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0XFF0E121B),
                ),
              ),
            ),
            SizedBox(
              height: ResponsiveScreen().heightMediaQuery(context, 50),
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(
                    Icons.view_list,
                    color: Color(0xFFcd4312),
                  ),
                  SizedBox(
                    width: ResponsiveScreen().widthMediaQuery(context, 10),
                  ),
                  Text(
                    'Main List',
                    style: TextStyle(
                      color: Color(0xFF9FA31C),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListMap(),
                  ),
                );
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(
                    Icons.chat,
                    color: Color(0xFFcd4312),
                  ),
                  SizedBox(
                    width: ResponsiveScreen().widthMediaQuery(context, 10),
                  ),
                  Text(
                    'Live Chat',
                    style: TextStyle(
                      color: Color(0xFF9FA31C),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LiveChat(),
                  ),
                );
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(
                    Icons.done,
                    color: Color(0xFFcd4312),
                  ),
                  SizedBox(
                    width: ResponsiveScreen().widthMediaQuery(context, 10),
                  ),
                  Text(
                    'Top Places',
                    style: TextStyle(
                      color: Color(0xFF9FA31C),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LiveFavoritePlaces(),
                  ),
                );
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: Color(0xFFcd4312),
                  ),
                  SizedBox(
                    width: ResponsiveScreen().widthMediaQuery(context, 10),
                  ),
                  Text(
                    'Favorites',
                    style: TextStyle(
                      color: Color(0xFF9FA31C),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoritesData(),
                  ),
                );
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(
                    Icons.edit,
                    color: Color(0xFFcd4312),
                  ),
                  SizedBox(
                    width: ResponsiveScreen().widthMediaQuery(context, 10),
                  ),
                  Text(
                    'Add Custom Marker',
                    style: TextStyle(
                      color: Color(0xFF9FA31C),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomMapList(),
                  ),
                );
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(
                    Icons.settings,
                    color: Color(0xFFcd4312),
                  ),
                  SizedBox(
                    width: ResponsiveScreen().widthMediaQuery(context, 10),
                  ),
                  Text(
                    'Private Chat',
                    style: TextStyle(
                      color: Color(0xFF9FA31C),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeChat(),
                  ),
                );
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(
                    Icons.settings,
                    color: Color(0xFFcd4312),
                  ),
                  SizedBox(
                    width: ResponsiveScreen().widthMediaQuery(context, 10),
                  ),
                  Text(
                    'List Settings',
                    style: TextStyle(
                      color: Color(0xFF9FA31C),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsApp(),
                  ),
                );
              },
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(
                    Icons.settings,
                    color: Color(0xFFcd4312),
                  ),
                  SizedBox(
                    width: ResponsiveScreen().widthMediaQuery(context, 10),
                  ),
                  Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Color(0xFF9FA31C),
                    ),
                  ),
                ],
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                final FacebookLogin _fbLogin = FacebookLogin();
                await _fbLogin.logOut();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => SigninFirebase(),
                    ),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
