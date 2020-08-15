import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:locationprojectflutter/presentation/pages/custom_map_list.dart';
import 'package:locationprojectflutter/presentation/pages/favorite_places.dart';
import 'package:locationprojectflutter/presentation/pages/home_chat.dart';
import 'package:locationprojectflutter/presentation/pages/live_chat.dart';
import 'package:locationprojectflutter/presentation/pages/live_favorite_places.dart';
import 'package:locationprojectflutter/presentation/pages/sign_in_firebase.dart';
import 'package:locationprojectflutter/presentation/pages/list_settings.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'dart:io' show Platform;

class AppBarTotal extends StatelessWidget implements PreferredSizeWidget {
  static final AppBarTotal _singleton = AppBarTotal.internal();

  factory AppBarTotal() => _singleton;

  AppBarTotal.internal();

  @override
  final Size preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      leading: IconButton(
        icon: Icon(
          Icons.navigate_before,
          color: Color(0xFFE9FFFF),
          size: 40,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
