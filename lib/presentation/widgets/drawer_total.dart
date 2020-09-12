import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:locationprojectflutter/core/constants/constants_colors.dart';
import 'package:locationprojectflutter/presentation/pages/page_custom_map_list.dart';
import 'package:locationprojectflutter/presentation/pages/page_favorite_places.dart';
import 'package:locationprojectflutter/presentation/pages/page_home_chat.dart';
import 'package:locationprojectflutter/presentation/pages/page_live_chat.dart';
import 'package:locationprojectflutter/presentation/pages/page_live_favorite_places.dart';
import 'package:locationprojectflutter/presentation/pages/page_list_settings.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/utils/shower_pages.dart';
import 'package:locationprojectflutter/presentation/utils/utils_app.dart';
import 'dart:io';

class DrawerTotal extends StatelessWidget {
  static final DrawerTotal _singleton = DrawerTotal.internal();

  factory DrawerTotal() => _singleton;

  DrawerTotal.internal();

  static const _platform =
      const MethodChannel("com.eliorcohen.locationprojectflutter.channel");

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: ConstantsColors.BLACK2,
      ),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: ResponsiveScreen().heightMediaQuery(context, 160),
              child: DrawerHeader(
                child: const Center(
                  child: Text(
                    'Hello user!',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 40,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: ConstantsColors.DARK_GRAY3,
                ),
              ),
            ),
            UtilsApp.dividerHeight(context, 10),
            _listTile(
              context,
              PageLiveChat(),
              Icons.chat,
              'Live Chat',
            ),
            _listTile(
              context,
              PageLiveFavoritePlaces(),
              Icons.done,
              'Top Places',
            ),
            _listTile(
              context,
              PageFavoritePlaces(),
              Icons.favorite,
              'Favorites',
            ),
            _listTile(
              context,
              PageCustomMapList(),
              Icons.edit,
              'Add Custom Marker',
            ),
            _listTile(
              context,
              PageHomeChat(),
              Icons.chat_bubble_outline,
              'Private Chat',
            ),
            _listTile(
              context,
              PageListSettings(),
              Icons.settings,
              'List Settings',
            ),
            kIsWeb
                ? Container()
                : Platform.isAndroid
                    ? ListTile(
                        title: Row(
                          children: <Widget>[
                            Icon(
                              Icons.info,
                              color: ConstantsColors.RED,
                            ),
                            UtilsApp.dividerWidth(context, 10),
                            Text(
                              'Credits',
                              style: TextStyle(
                                color: ConstantsColors.LIGHT_DARK_GREEN,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          _showNativeView();
                        },
                      )
                    : Container(),
            ListTile(
              title: Row(
                children: <Widget>[
                  Icon(
                    Icons.exit_to_app,
                    color: ConstantsColors.RED,
                  ),
                  UtilsApp.dividerWidth(context, 10),
                  Text(
                    'Sign Out',
                    style: TextStyle(
                      color: ConstantsColors.LIGHT_DARK_GREEN,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                FacebookLogin _fbLogin = FacebookLogin();
                await FirebaseAuth.instance.signOut().then(
                      (value) async => {
                        await _fbLogin.logOut().then(
                              (value) => ShowerPages
                                  .pushRemoveReplacementPageSignInFirebase(
                                      context),
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

  Widget _listTile(
      BuildContext context, var cls, IconData iconData, String text) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            iconData,
            color: ConstantsColors.RED,
          ),
          UtilsApp.dividerWidth(context, 10),
          Text(
            text,
            style: TextStyle(
              color: ConstantsColors.LIGHT_DARK_GREEN,
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.of(context).pop();
        ShowerPages.pushDrawerTotal(context, cls);
      },
    );
  }

  void _showNativeView() async {
    await _platform.invokeMethod("showNativeView");
  }
}
