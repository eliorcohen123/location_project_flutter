import 'package:flutter/material.dart';
import 'package:locationprojectflutter/data/models/model_live_favorites/results_live_favorites.dart';

class LiveFavoritePlacesProvider extends ChangeNotifier {
  List<ResultsFirestore> _places = List();
  bool _checkingBottomSheet = false;

  List<ResultsFirestore> get placesGet => _places;

  bool get checkingBottomSheetGet => _checkingBottomSheet;

  void isCheckingBottomSheet(bool checkingBottomSheet) {
    _checkingBottomSheet = checkingBottomSheet;
    notifyListeners();
  }

  void places(List<ResultsFirestore> places) {
    _places = places;
    notifyListeners();
  }
}
