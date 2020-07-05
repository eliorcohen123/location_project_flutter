import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/settings_app_provider.dart';
import 'package:locationprojectflutter/presentation/widgets/appbar_total.dart';
import 'package:locationprojectflutter/presentation/widgets/drawer_total.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_map.dart';

class SettingsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsAppProvider>(
      builder: (context, results, child) {
        return SettingsAppProv();
      },
    );
  }
}

class SettingsAppProv extends StatefulWidget {
  const SettingsAppProv({Key key}) : super(key: key);

  @override
  _SettingsAppProvState createState() => _SettingsAppProvState();
}

class _SettingsAppProvState extends State<SettingsAppProv> {
  var _provider;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<SettingsAppProvider>(context, listen: false);

    _initGetSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBarTotal(),
      body: Container(
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
                    style: TextStyle(color: Colors.greenAccent),
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
                    style: TextStyle(color: Colors.greenAccent),
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
                value: _provider.valueRadiusGet,
                min: 0.0,
                max: 50000.0,
                divisions: 50000,
                activeColor: Colors.indigo,
                inactiveColor: Colors.grey,
                label: _provider.valueRadiusGet.round().toString(),
                onChanged: (double newValue) {
                  _provider.valueRadius(newValue);

                  _addRadiusSearchToSF(_provider.valueRadiusGet);
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
                    style: TextStyle(color: Colors.greenAccent),
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
                value: _provider.valueGeofenceGet,
                min: 500.0,
                max: 1000.0,
                divisions: 500,
                activeColor: Colors.indigo,
                inactiveColor: Colors.grey,
                label: _provider.valueGeofenceGet.round().toString(),
                onChanged: (double newValue) {
                  _provider.valueGeofence(newValue);

                  _addGeofenceToSF(_provider.valueGeofenceGet);
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

  void _initGetSharedPrefs() {
    SharedPreferences.getInstance().then(
      (prefs) {
        _provider.sharedPref(prefs);
        _provider.valueRadius(
            _provider.sharedGet.getDouble('rangeRadius') ?? 5000.0);
        _provider.valueGeofence(
            _provider.sharedGet.getDouble('rangeGeofence') ?? 500.0);
      },
    );
  }

  void _addRadiusSearchToSF(double value) async {
    _provider.sharedGet.setDouble('rangeRadius', value);
  }

  void _addGeofenceToSF(double value) async {
    _provider.sharedGet.setDouble('rangeGeofence', value);
  }

  void _addOpenToSF(String value) async {
    if (value == 'Open') {
      _provider.sharedGet.setString('open', '&opennow=true');
    } else if (value == 'All(Open + Close)') {
      _provider.sharedGet.setString('open', '');
    }
  }
}
