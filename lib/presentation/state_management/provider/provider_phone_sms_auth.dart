import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderPhoneSMSAuth extends ChangeNotifier {
  bool _isSuccess, _isLoading = false;
  String _textError = '', _textOk = '', _verificationId;
  SharedPreferences _sharedPrefs;

  bool get isSuccessGet => _isSuccess;

  bool get isLoadingGet => _isLoading;

  String get textErrorGet => _textError;

  String get textOkGet => _textOk;

  String get verificationIdGet => _verificationId;

  SharedPreferences get sharedGet => _sharedPrefs;

  void isSuccess(bool isSuccess) {
    _isSuccess = isSuccess;
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

  void textOk(String textOk) {
    _textOk = textOk;
    notifyListeners();
  }

  void verificationId(String verificationId) {
    _verificationId = verificationId;
    notifyListeners();
  }

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }
}
