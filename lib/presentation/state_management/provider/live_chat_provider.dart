import 'package:flutter/material.dart';
import 'package:locationprojectflutter/data/models/model_live_chat/results_live_chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveChatProvider extends ChangeNotifier {
  List<ResultsLiveChat> _places = List();
  SharedPreferences _sharedPrefs;

  SharedPreferences get sharedGet => _sharedPrefs;

  List<ResultsLiveChat> get placesGet => _places;

  void sharedPref(SharedPreferences sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    notifyListeners();
  }

  void places(List<ResultsLiveChat> places) {
    _places = places;
    notifyListeners();
  }
}
