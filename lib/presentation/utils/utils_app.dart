import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';

class UtilsApp {
  static final UtilsApp _singleton = UtilsApp._internal();

  factory UtilsApp() {
    return _singleton;
  }

  UtilsApp._internal();

  static bool isRTL(BuildContext context) {
    final TextDirection currentDirection = Directionality.of(context);
    bool isRTL = currentDirection == TextDirection.rtl;
    return isRTL;
  }

  static Widget dividerHeight(BuildContext context, double height) {
    return SizedBox(
      height: ResponsiveScreen().heightMediaQuery(context, height),
    );
  }

  static Widget dividerWidth(BuildContext context, double width) {
    return SizedBox(
      width: ResponsiveScreen().widthMediaQuery(context, width),
    );
  }
}
