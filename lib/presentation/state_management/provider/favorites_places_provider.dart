import 'package:flutter/material.dart';
import 'package:locationprojectflutter/data/data_resources/locals/sqflite_helper.dart';
import 'package:locationprojectflutter/data/models/model_sqfl/results_sqfl.dart';

class FavoritesPlacesProvider extends ChangeNotifier {
  SQFLiteHelper _db = SQFLiteHelper();
  List<ResultsSqfl> _resultsSqfl = List();
  bool _checkingBottomSheet = false;

  bool get checkingBottomSheetGet => _checkingBottomSheet;

  List<ResultsSqfl> get resultsSqflGet => _resultsSqfl;

  void isCheckingBottomSheet(bool checkingBottomSheet) {
    _checkingBottomSheet = checkingBottomSheet;
    notifyListeners();
  }

  void deleteItem(ResultsSqfl result, int index) {
    _db.deleteResult(result.id).then(
      (_) {
        _resultsSqfl.removeAt(index);
        notifyListeners();
      },
    );
  }

  void deleteData() {
    _db.deleteData().then(
      (_) {
        _resultsSqfl.clear();
        notifyListeners();
      },
    );
  }

  void getItems() {
    _db.getAllResults().then(
      (results) {
        _resultsSqfl.clear();
        results.forEach(
          (result) {
            _resultsSqfl.add(
              ResultsSqfl.fromSqfl(result),
            );
            notifyListeners();
          },
        );
      },
    );
  }
}
