import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:locationprojectflutter/data/data_resources/locals/sqflite_helper.dart';
import 'package:locationprojectflutter/data/models/model_sqfl/results_sqfl.dart';
import 'package:locationprojectflutter/presentation/pages/favorites_data.dart';

class ResultsSqflProvider extends ChangeNotifier {
  SQFLiteHelper _db = SQFLiteHelper();
  List<ResultsSqfl> _resultsSqfl = List();

  void initList(List<ResultsSqfl> resultsSqfl) {
    this._resultsSqfl = resultsSqfl;
  }

  void addItem(String name, String vicinity, double lat, double lng,
      String photo, BuildContext context) {
    var add = ResultsSqfl.sqfl(name, vicinity, lat, lng, photo);
    _db.addResult(add).then(
      (_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavoritesData(),
          ),
        );
        notifyListeners();
      },
    );
  }

  void updateItem(int id, String name, String vicinity, double lat, double lng,
      String photo, BuildContext context) {
    _db
        .updateResult(
      ResultsSqfl.fromSqfl(
        {
          'id': id,
          'name': name,
          'vicinity': vicinity,
          'lat': lat,
          'lng': lng,
          'photo': photo
        },
      ),
    )
        .then(
      (_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavoritesData(),
          ),
        );
        notifyListeners();
      },
    );
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

  Future getItems() async {
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
