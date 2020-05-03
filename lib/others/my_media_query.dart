import 'package:flutter/material.dart';

class MyMediaQuery {
  static final MyMediaQuery _singleton = MyMediaQuery._internal();

  factory MyMediaQuery() {
    return _singleton;
  }

  MyMediaQuery._internal();

  double widthMediaQuery(BuildContext context, double width) {
    return MediaQuery.of(context).size.width * width / 375;
  }

  double heightMediaQuery(BuildContext context, double height) {
    return MediaQuery.of(context).size.height * height / 667;
  }
}
