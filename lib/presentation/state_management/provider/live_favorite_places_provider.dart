import 'package:flutter/material.dart';
import 'package:locationprojectflutter/data/models/model_live_favorites/results_live_favorites.dart';

class LiveFavoritePlacesProvider extends ChangeNotifier {
  List<ResultsFirestore> _places = List();

  List<ResultsFirestore> get placesGet => _places;

  void places(List<ResultsFirestore> places) {
    _places = places;
    notifyListeners();
  }
}
