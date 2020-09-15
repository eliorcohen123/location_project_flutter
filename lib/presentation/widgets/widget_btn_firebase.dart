import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';

class WidgetBtnFirebase extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const WidgetBtnFirebase({Key key, @required this.text, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveScreen().heightMediaQuery(context, 50),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        highlightElevation: 0.0,
        splashColor: Colors.greenAccent,
        highlightColor: Colors.lightGreenAccent,
        elevation: 0.0,
        color: Colors.greenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}
