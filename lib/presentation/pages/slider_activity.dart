import 'package:flutter/material.dart';
import 'package:locationprojectflutter/others/my_media_query.dart';
import 'package:locationprojectflutter/presentation/pages/list_map_activity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SliderActivity extends StatefulWidget {
  const SliderActivity({Key key}) : super(key: key);

  @override
  _SliderActivityState createState() => _SliderActivityState();
}

class _SliderActivityState extends State<SliderActivity> {
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
                          width: MyMediaQuery().widthMediaQuery(context, 5)),
                      Icon(Icons.my_location,
                          size: MyMediaQuery().heightMediaQuery(context, 40)),
                    ],
                  ),
                  Slider(
                      value: _valueRadius,
                      min: 0.0,
                      max: 50000.0,
                      divisions: 50000,
                      activeColor: Colors.green,
                      inactiveColor: Colors.grey,
                      label: _valueRadius.toString(),
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
