import 'package:flutter/material.dart';
import 'package:locationprojectflutter/data/models/model_live_favorites/results_live_favorites.dart';

class LiveFavoritePlacesProvider extends ChangeNotifier {
  bool _checkingBottomSheet = false;
  List<ResultsFirestore> _places = List();

  bool get checkingBottomSheetGet => _checkingBottomSheet;

  List<ResultsFirestore> get placesGet => _places;

  void isCheckingBottomSheet(bool checkingBottomSheet) {
    _checkingBottomSheet = checkingBottomSheet;
    notifyListeners();
  }

  void places(List<ResultsFirestore> places) {
    _places = places;
    notifyListeners();
  }
}
