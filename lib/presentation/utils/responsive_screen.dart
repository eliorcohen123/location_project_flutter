import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ResponsiveScreen {
  static final ResponsiveScreen _singleton = ResponsiveScreen._internal();

  factory ResponsiveScreen() {
    return _singleton;
  }

  ResponsiveScreen._internal();

  double widthMediaQuery(BuildContext context, double width) {
    return MediaQuery.of(context).size.width * width / 375;
  }

  double heightMediaQuery(BuildContext context, double height) {
    return MediaQuery.of(context).size.height * height / 667;
  }
}
