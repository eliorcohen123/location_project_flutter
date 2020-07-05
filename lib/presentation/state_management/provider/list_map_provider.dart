import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListMapProvider extends ChangeNotifier {
  bool _activeSearch = false, _activeNav = false;
  int _count;
  SharedPreferences _sharedPrefs;

  SharedPreferences get sharedGet => _sharedPrefs;

  bool get activeSearchGet => _activeSearch;

  bool get activeNavGet => _activeNav;

  int get countGet => _count;

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }

  void isActiveSearch(bool activeSearch) {
    _activeSearch = activeSearch;
    notifyListeners();
  }

  void isActiveNav(bool activeNav) {
    _activeNav = activeNav;
    notifyListeners();
  }

  void count(int count) {
    _count = count;
    notifyListeners();
  }
}
