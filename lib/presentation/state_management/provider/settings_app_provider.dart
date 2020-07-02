import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsAppProvider extends ChangeNotifier {
  double _valueRadius, _valueGeofence;
  SharedPreferences _sharedPrefs;

  SharedPreferences get sharedGet => _sharedPrefs;

  double get valueRadiusGet => _valueRadius;

  double get valueGeofenceGet => _valueGeofence;

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }

  void valueGeofence(double valueGeofence) {
    _valueGeofence = valueGeofence;
    notifyListeners();
  }

  void valueRadius(double valueRadius) {
    _valueRadius = valueRadius;
    notifyListeners();
  }
}
