import 'package:flutter/material.dart';
import 'package:locationprojectflutter/presentation/pages/favorites_data.dart';
import 'package:locationprojectflutter/presentation/pages/slider_location.dart';
import 'package:locationprojectflutter/presentation/widgets/responsive_screen.dart';

class DrawerTotal {
  static final DrawerTotal _singleton = DrawerTotal._internal();

  factory DrawerTotal() {
    return _singleton;
  }

  DrawerTotal._internal();

  Widget drawerImp(BuildContext context) {
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
                    style: TextStyle(color: Color(0xFFF5FA55), fontSize: 40),
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
                    Icons.favorite,
                    color: Color(0xFFcd4312),
                  ),
                  SizedBox(
                    width: ResponsiveScreen().widthMediaQuery(context, 10),
                  ),
                  Text(
                    'Credits',
                    style: TextStyle(
                      color: Color(0xFF9FA31C),
                    ),
                  ),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
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
                    'List settings',
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
                      builder: (context) => SliderLocation(),
                    ));
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
                    'Favorites list',
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
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
