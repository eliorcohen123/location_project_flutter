import 'package:flutter/material.dart';

class AppBarTotal extends StatelessWidget with PreferredSizeWidget {
  static final AppBarTotal _instance = AppBarTotal.internal();

  factory AppBarTotal() => _instance;

  AppBarTotal.internal();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Text(
        'Lovely Favorite Places',
        style: TextStyle(
          color: Color(0xFFE9FFFF),
        ),
      ),
      iconTheme: IconThemeData(
        color: Color(0xFFE9FFFF),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
