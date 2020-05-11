import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:locationprojectflutter/presentation/widgets/responsive_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_map.dart';

class SliderLocation extends StatefulWidget {
  const SliderLocation({Key key}) : super(key: key);

  @override
  _SliderLocationState createState() => _SliderLocationState();
}

class _SliderLocationState extends State<SliderLocation> {
  SharedPreferences _sharedPrefs;
  double _valueRadius;

  @override
  void initState() {
    super.initState();

    _initSharedPref();
    _initGetSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Lovely Favorite Places',
            style: TextStyle(color: Color(0xFFE9FFFF)),
          ),
          iconTheme: new IconThemeData(color: Color(0xFFE9FFFF)),
        ),
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.blueGrey,
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Open Places",
                      style: TextStyle(
                        color: Colors.greenAccent,
                      ),
                    ),
                    SizedBox(
                        width: ResponsiveScreen().widthMediaQuery(context, 5)),
                    Icon(Icons.open_with,
                        color: Colors.greenAccent,
                        size: ResponsiveScreen().heightMediaQuery(context, 40)),
                  ],
                ),
                RadioButtonGroup(
                  labels: [
                    "Open",
                    "All(Open + Close)",
                  ],
                  labelStyle: TextStyle(color: Colors.indigo),
                  activeColor: Colors.greenAccent,
                  onSelected: (String label) => _addOpenToSF(label),
                ),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 20),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Distance",
                      style: TextStyle(
                        color: Colors.greenAccent,
                      ),
                    ),
                    SizedBox(
                        width: ResponsiveScreen().widthMediaQuery(context, 5)),
                    Icon(Icons.my_location,
                        color: Colors.greenAccent,
                        size: ResponsiveScreen().heightMediaQuery(context, 40)),
                  ],
                ),
                Slider(
                    value: _valueRadius,
                    min: 0.0,
                    max: 50000.0,
                    divisions: 50000,
                    activeColor: Colors.indigo,
                    inactiveColor: Colors.grey,
                    label: _valueRadius.round().toString(),
                    onChanged: (double newValue) {
                      setState(() {
                        _valueRadius = newValue;
                        _addRadiusToSF(_valueRadius);
                      });
                    },
                    semanticFormatterCallback: (double newValue) {
                      return '${newValue.round()}';
                    }),
                SizedBox(
                  height: ResponsiveScreen().heightMediaQuery(context, 100),
                ),
                RaisedButton(
                  child: Text('Return'),
                  color: Colors.greenAccent,
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListMap(),
                      )),
                )
              ])),
        ),
        drawer: DrawerTotal());
  }

  _initSharedPref() async {
    _sharedPrefs = await SharedPreferences.getInstance();
  }

  _initGetSharedPref() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() => _sharedPrefs = prefs);
      _valueRadius = prefs.getDouble('rangeRadius') ?? 5000.0;
    });
  }

  _addRadiusToSF(double value) async {
    _sharedPrefs.setDouble('rangeRadius', value);
  }

  _addOpenToSF(String value) async {
    if (value == 'Open') {
      _sharedPrefs.setString('open', '&opennow=true');
    } else if (value == 'All(Open + Close)') {
      _sharedPrefs.setString('open', '');
    }
  }
}
