import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapListProvider extends ChangeNotifier {
  List<Marker> _markers = <Marker>[];
  SharedPreferences _sharedPrefs;
  bool _search = false;

  List<Marker> get markersGet => _markers;

  SharedPreferences get sharedGet => _sharedPrefs;

  bool get searchGet => _search;

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }

  void clearMarkers() {
    _markers.clear();
    notifyListeners();
  }

  void isSearch(bool search) {
    _search = search;
    notifyListeners();
  }
}
