import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderListMap extends ChangeNotifier {
  SharedPreferences _sharedPrefs;
  bool _isActiveSearch = false,
      _isActiveNav = false,
      _isCheckingBottomSheet = false,
      _isSearching = true,
      _isSearchingAfter = false;
  int _count;

  SharedPreferences get sharedGet => _sharedPrefs;

  bool get isSearchingAfterGet => _isSearchingAfter;

  bool get isSearchingGet => _isSearching;

  bool get isCheckingBottomSheetGet => _isCheckingBottomSheet;

  bool get isActiveSearchGet => _isActiveSearch;

  bool get isActiveNavGet => _isActiveNav;

  int get countGet => _count;

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }

  void isSearching(bool isSearching) {
    _isSearching = isSearching;
    notifyListeners();
  }

  void isSearchAfter(bool isSearchAfter) {
    _isSearchingAfter = isSearchAfter;
    notifyListeners();
  }

  void isCheckingBottomSheet(bool isCheckingBottomSheet) {
    _isCheckingBottomSheet = isCheckingBottomSheet;
    notifyListeners();
  }

  void isActiveSearch(bool isActiveSearch) {
    _isActiveSearch = isActiveSearch;
    notifyListeners();
  }

  void isActiveNav(bool isActiveNav) {
    _isActiveNav = isActiveNav;
    notifyListeners();
  }

  void count(int count) {
    _count = count;
    notifyListeners();
  }
}
