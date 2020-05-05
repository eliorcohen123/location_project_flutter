import 'package:flutter/material.dart';
import 'package:locationprojectflutter/presentation/others/responsive_screen.dart';
import 'package:locationprojectflutter/presentation/pages/list_map_activity.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Distance"),
                      SizedBox(
                          width: ResponsiveScreen().widthMediaQuery(context, 5)),
                      Icon(Icons.my_location,
                          size: ResponsiveScreen().heightMediaQuery(context, 40)),
                    ],
                  ),
                  Slider(
                      value: _valueRadius,
                      min: 0.0,
                      max: 50000.0,
                      divisions: 50000,
                      activeColor: Colors.green,
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
                  RaisedButton(
                    child: Text('Save'),
                    color: Colors.green,
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ListMapActivity(),
                        )),
                  )
                ]))));
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
}
