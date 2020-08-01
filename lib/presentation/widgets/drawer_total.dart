import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:locationprojectflutter/presentation/pages/custom_map_list.dart';
import 'package:locationprojectflutter/presentation/pages/favorite_places.dart';
import 'package:locationprojectflutter/presentation/pages/home_chat.dart';
import 'package:locationprojectflutter/presentation/pages/live_chat.dart';
import 'package:locationprojectflutter/presentation/pages/live_favorite_places.dart';
import 'package:locationprojectflutter/presentation/pages/sign_in_firebase.dart';
import 'package:locationprojectflutter/presentation/pages/list_settings.dart';
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
            _listTile(
              context,
              LiveChat(),
              Icons.chat,
              'Live Chat',
            ),
            _listTile(
              context,
              LiveFavoritePlaces(),
              Icons.done,
              'Top Places',
            ),
            _listTile(
              context,
              FavoritePlaces(),
              Icons.favorite,
              'Favorites',
            ),
            _listTile(
              context,
              CustomMapList(),
              Icons.edit,
              'Add Custom Marker',
            ),
            _listTile(
              context,
              HomeChat(),
              Icons.chat_bubble_outline,
              'Private Chat',
            ),
            _listTile(
              context,
              ListSettings(),
              Icons.settings,
              'List Settings',
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(
                    Icons.exit_to_app,
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
                FacebookLogin _fbLogin = FacebookLogin();
                await FirebaseAuth.instance.signOut().then(
                      (value) async => {
                    await _fbLogin.logOut().then(
                          (value) =>
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => SignInFirebase(),
                              ),
                                  (Route<dynamic> route) => false),
                    ),
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _listTile(BuildContext context, cls, IconData iconData, String text) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            iconData,
            color: Color(0xFFcd4312),
          ),
          SizedBox(
            width: ResponsiveScreen().widthMediaQuery(context, 10),
          ),
          Text(
            text,
            style: TextStyle(
              color: Color(0xFF9FA31C),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => cls,
          ),
        );
      },
    );
  }
}
