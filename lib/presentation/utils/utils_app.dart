import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';

class UtilsApp {
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
