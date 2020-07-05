import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListMapProvider extends ChangeNotifier {
  bool _activeSearch = false, _activeNav = false, _checkingBottomSheet = false, _search = false, _searchAfter = false;
  int _count;
  SharedPreferences _sharedPrefs;

  SharedPreferences get sharedGet => _sharedPrefs;

  bool get searchAfterGet => _searchAfter;

  bool get searchGet => _search;

  bool get checkingBottomSheetGet => _checkingBottomSheet;

  bool get activeSearchGet => _activeSearch;

  bool get activeNavGet => _activeNav;

  int get countGet => _count;

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }

  void isSearch(bool search) {
    _search = search;
    notifyListeners();
  }

  void isSearchAfter(bool searchAfter) {
    _searchAfter = searchAfter;
    notifyListeners();
  }

  void isCheckingBottomSheet(bool checkingBottomSheet) {
    _checkingBottomSheet = checkingBottomSheet;
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
