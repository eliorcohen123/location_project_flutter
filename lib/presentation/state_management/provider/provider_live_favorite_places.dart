import 'package:flutter/material.dart';
import 'package:locationprojectflutter/data/models/model_live_favorites/results_live_favorites.dart';

class ProviderLiveFavoritePlaces extends ChangeNotifier {
  List<ResultsFirestore> _places = [];
  bool _isCheckingBottomSheet = false;

  List<ResultsFirestore> get placesGet => _places;

  bool get isCheckingBottomSheetGet => _isCheckingBottomSheet;

  void places(List<ResultsFirestore> places) {
    _places = places;
    notifyListeners();
  }

  void isCheckingBottomSheet(bool isCheckingBottomSheet) {
    _isCheckingBottomSheet = isCheckingBottomSheet;
    notifyListeners();
  }
}
