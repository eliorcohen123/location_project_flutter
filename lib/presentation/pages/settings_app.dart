import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_map.dart';

class SettingsApp extends StatefulWidget {
  const SettingsApp({Key key}) : super(key: key);

  @override
  _SettingsAppState createState() => _SettingsAppState();
}

class _SettingsAppState extends State<SettingsApp> {
  SharedPreferences _sharedPrefs;
  double _valueRadius, _valueGeofence;

  @override
  void initState() {
    super.initState();

    _initGetSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    width: ResponsiveScreen().widthMediaQuery(context, 5),
                  ),
                  Icon(
                    Icons.open_with,
                    color: Colors.greenAccent,
                    size: ResponsiveScreen().heightMediaQuery(context, 40),
                  ),
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
                    "Radius Search",
                    style: TextStyle(
                      color: Colors.greenAccent,
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveScreen().widthMediaQuery(context, 5),
                  ),
                  Icon(
                    Icons.my_location,
                    color: Colors.greenAccent,
                    size: ResponsiveScreen().heightMediaQuery(context, 40),
                  ),
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
                  setState(
                    () {
                      _valueRadius = newValue;
                      _addRadiusSearchToSF(_valueRadius);
                    },
                  );
                },
                semanticFormatterCallback: (double newValue) {
                  return '${newValue.round()}';
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Radius Geofence",
                    style: TextStyle(
                      color: Colors.greenAccent,
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveScreen().widthMediaQuery(context, 5),
                  ),
                  Icon(
                    Icons.location_searching,
                    color: Colors.greenAccent,
                    size: ResponsiveScreen().heightMediaQuery(context, 40),
                  ),
                ],
              ),
              Slider(
                value: _valueGeofence,
                min: 500.0,
                max: 1000.0,
                divisions: 500,
                activeColor: Colors.indigo,
                inactiveColor: Colors.grey,
                label: _valueGeofence.round().toString(),
                onChanged: (double newValue) {
                  setState(
                    () {
                      _valueGeofence = newValue;
                      _addGeofenceToSF(_valueGeofence);
                    },
                  );
                },
                semanticFormatterCallback: (double newValue) {
                  return '${newValue.round()}';
                },
              ),
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
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      drawer: DrawerTotal(),
    );
  }

  _initGetSharedPref() {
    SharedPreferences.getInstance().then(
      (prefs) {
        setState(() => _sharedPrefs = prefs);
        _valueRadius = prefs.getDouble('rangeRadius') ?? 5000.0;
        _valueGeofence = prefs.getDouble('rangeGeofence') ?? 500.0;
      },
    );
  }

  _addRadiusSearchToSF(double value) async {
    _sharedPrefs.setDouble('rangeRadius', value);
  }

  _addGeofenceToSF(double value) async {
    _sharedPrefs.setDouble('rangeGeofence', value);
  }

  _addOpenToSF(String value) async {
    if (value == 'Open') {
      _sharedPrefs.setString('open', '&opennow=true');
    } else if (value == 'All(Open + Close)') {
      _sharedPrefs.setString('open', '');
    }
  }
}
