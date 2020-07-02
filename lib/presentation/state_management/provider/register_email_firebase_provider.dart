import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterEmailFirebaseProvider extends ChangeNotifier {
  bool _success, _loading = false;
  String _textError = '';
  SharedPreferences _sharedPrefs;

  SharedPreferences get sharedGet => _sharedPrefs;

  bool get successGet => _success;

  bool get loadingGet => _loading;

  String get textErrorGet => _textError;

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }

  void success(bool success) {
    _success = success;
    notifyListeners();
  }

  void loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  void textError(String textError) {
    _textError = textError;
    notifyListeners();
  }
}
