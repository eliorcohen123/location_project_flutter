import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:locationprojectflutter/presentation/state_management/provider/list_settings_provider.dart';
import 'package:locationprojectflutter/presentation/utils/responsive_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_map.dart';

class ListSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ListSettingsProvider>(
      builder: (context, results, child) {
        return ChatSettingsProv();
      },
    );
  }
}

class ChatSettingsProv extends StatefulWidget {
  const ChatSettingsProv({Key key}) : super(key: key);

  @override
  _ChatSettingsProvState createState() => _ChatSettingsProvState();
}

class _ChatSettingsProvState extends State<ChatSettingsProv> {
  ListSettingsProvider _provider;

  @override
  void initState() {
    super.initState();

    _provider = Provider.of<ListSettingsProvider>(context, listen: false);

    _initGetSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: _appBar(),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _openPlaces(),
              SizedBox(
                height: ResponsiveScreen().heightMediaQuery(context, 20),
              ),
              _radiusSearch(),
              _radiusGeofence(),
              SizedBox(
                height: ResponsiveScreen().heightMediaQuery(context, 100),
              ),
              _buttonSave()
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      leading: IconButton(
        icon: Icon(
          Icons.navigate_before,
          color: Color(0xFFE9FFFF),
          size: 40,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _openPlaces() {
    return Column(
      children: [
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
            'Open',
            'All(Open + Close)',
          ],
          picked: _provider.valueOpenGet,
          labelStyle: TextStyle(color: Colors.indigo),
          activeColor: Colors.greenAccent,
          onSelected: (String label) => {
            _provider.valueOpen(label),
          },
        ),
      ],
    );
  }

  Widget _radiusSearch() {
    return Column(
      children: [
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
          },
          semanticFormatterCallback: (double newValue) {
            return '${newValue.round()}';
          },
        ),
      ],
    );
  }

  Widget _radiusGeofence() {
    return Column(
      children: [
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
          },
          semanticFormatterCallback: (double newValue) {
            return '${newValue.round()}';
          },
        ),
      ],
    );
  }

  Widget _buttonSave() {
    return RaisedButton(
      child: Text('Save'),
      color: Colors.greenAccent,
      onPressed: () => {
        _addOpenToSF(_provider.valueOpenGet),
        _addRadiusSearchToSF(_provider.valueRadiusGet),
        _addGeofenceToSF(_provider.valueGeofenceGet),
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListMap(),
          ),
        ),
      },
    );
  }

  void _initGetSharedPrefs() {
    SharedPreferences.getInstance().then(
      (prefs) {
        _provider.sharedPref(prefs);

        _provider.valueOpen(_provider.sharedGet.getString('open') ?? '');

        _provider.valueOpenGet == '&opennow=true'
            ? _provider.valueOpen('Open')
            : _provider.valueOpenGet == ''
                ? _provider.valueOpen('All(Open + Close)')
                : _provider.valueOpen('All(Open + Close)');

        _provider.valueRadius(
            _provider.sharedGet.getDouble('rangeRadius') ?? 5000.0);

        _provider.valueGeofence(
            _provider.sharedGet.getDouble('rangeGeofence') ?? 500.0);
      },
    );
  }

  void _addOpenToSF(String value) async {
    if (value == 'Open') {
      _provider.sharedGet.setString('open', '&opennow=true');
    } else if (value == 'All(Open + Close)') {
      _provider.sharedGet.setString('open', '');
    }
  }

  void _addRadiusSearchToSF(double value) async {
    _provider.sharedGet.setDouble('rangeRadius', value);
  }

  void _addGeofenceToSF(double value) async {
    _provider.sharedGet.setDouble('rangeGeofence', value);
  }
}
