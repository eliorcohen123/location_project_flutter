import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderListMap extends ChangeNotifier {
  SharedPreferences _sharedPrefs;
  bool _isActiveSearch = false,
      _isActiveNav = false,
      _isCheckingBottomSheet = false,
      _isSearching = true,
      _isSearchingAfter = false,
      _isDisplayGrid = false;
  int _count;
  String _finalTagsChips;
  List<String> _tagsChips = [];

  SharedPreferences get sharedGet => _sharedPrefs;

  bool get isSearchingAfterGet => _isSearchingAfter;

  bool get isSearchingGet => _isSearching;

  bool get isCheckingBottomSheetGet => _isCheckingBottomSheet;

  bool get isActiveSearchGet => _isActiveSearch;

  bool get isActiveNavGet => _isActiveNav;

  bool get isDisplayGridGet => _isDisplayGrid;

  int get countGet => _count;

  String get finalTagsChipsGet => _finalTagsChips;

  List<String> get tagsChipsGet => _tagsChips;

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

  void isDisplayGrid(bool isDisplayGrid) {
    _isDisplayGrid = isDisplayGrid;
    notifyListeners();
  }

  void count(int count) {
    _count = count;
    notifyListeners();
  }

  void finalTagsChips(String finalTagsChips) {
    _finalTagsChips = finalTagsChips
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll(', ', '')
        .replaceAll('Banks', '|bank')
        .replaceAll('Bars', '|bar|night_club')
        .replaceAll('Beauty', '|beauty_salon|hair_care')
        .replaceAll('Books', '|book_store|library')
        .replaceAll('Bus stations', '|bus_station')
        .replaceAll('Cars', '|car_dealer|car_rental|car_repair|car_wash')
        .replaceAll('Clothing', '|clothing_store')
        .replaceAll('Doctors', '|doctor')
        .replaceAll('Gas stations', '|gas_station')
        .replaceAll('Gym', '|gym')
        .replaceAll('Jewelries', '|jewelry_store')
        .replaceAll('Parks', '|park|amusement_park|parking|rv_park')
        .replaceAll('Restaurants', '|food|restaurant|cafe|bakery')
        .replaceAll('School', '|school')
        .replaceAll('Spa', '|spa');
    notifyListeners();
  }

  void tagsChips(List<String> tagsChips) {
    _tagsChips = tagsChips;
    notifyListeners();
  }
}
