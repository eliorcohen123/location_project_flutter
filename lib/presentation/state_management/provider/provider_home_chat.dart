import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderHomeChat extends ChangeNotifier {
  SharedPreferences _sharedPrefs;

  SharedPreferences get sharedGet => _sharedPrefs;

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }
}
