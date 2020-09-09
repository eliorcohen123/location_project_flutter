import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderMapList extends ChangeNotifier {
  SharedPreferences _sharedPrefs;
  List<Marker> _markers = [];
  bool _isSearching = false;

  SharedPreferences get sharedGet => _sharedPrefs;

  List<Marker> get markersGet => _markers;

  bool get isSearchingGet => _isSearching;

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }

  void clearMarkers() {
    _markers.clear();
    notifyListeners();
  }

  void isSearching(bool isSearching) {
    _isSearching = isSearching;
    notifyListeners();
  }
}
