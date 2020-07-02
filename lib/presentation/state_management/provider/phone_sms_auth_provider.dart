import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneSMSAuthProvider extends ChangeNotifier {
  bool _success, _loading = false;
  String _textError = '', _textOk = '', _verificationId;
  SharedPreferences _sharedPrefs;

  SharedPreferences get sharedGet => _sharedPrefs;

  bool get successGet => _success;

  bool get loadingGet => _loading;

  String get textErrorGet => _textError;

  String get textOkGet => _textOk;

  String get verificationIdGet => _verificationId;

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

  void textOk(String textOk) {
    _textOk = textOk;
    notifyListeners();
  }

  void verificationId(String verificationId) {
    _verificationId = verificationId;
    notifyListeners();
  }
}
