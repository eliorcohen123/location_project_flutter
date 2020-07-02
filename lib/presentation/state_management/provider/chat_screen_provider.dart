import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreenProvider extends ChangeNotifier {
  bool _isLoading = false, _isShowSticker = false;
  SharedPreferences _sharedPrefs;

  bool get isLoadingGet => _isLoading;

  bool get isShowStickerGet => _isShowSticker;

  SharedPreferences get sharedPrefsGet => _sharedPrefs;

  void isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void isShowSticker(bool isShowSticker) {
    _isShowSticker = isShowSticker;
    notifyListeners();
  }

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }
}
