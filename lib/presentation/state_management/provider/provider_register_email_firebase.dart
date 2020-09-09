import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderRegisterEmailFirebase extends ChangeNotifier {
  SharedPreferences _sharedPrefs;
  bool _iSuccess, _isLoading = false;
  String _textError = '';

  SharedPreferences get sharedGet => _sharedPrefs;

  bool get isSuccessGet => _iSuccess;

  bool get isLoadingGet => _isLoading;

  String get textErrorGet => _textError;

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }

  void isSuccess(bool isSuccess) {
    _iSuccess = isSuccess;
    notifyListeners();
  }

  void isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void textError(String textError) {
    _textError = textError;
    notifyListeners();
  }
}
