import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:locationprojectflutter/data/databases/sqflite_helper.dart';
import 'package:locationprojectflutter/data/models/model_sqfl/results_sqfl.dart';
import 'package:locationprojectflutter/presentation/pages/favorites_data.dart';

class ResultsSqflProvider extends ChangeNotifier {
  SQFLiteHelper _db = SQFLiteHelper();
  List<ResultsSqfl> _resultsSqfl = List();

  initList(List<ResultsSqfl> resultsSqfl) {
    this._resultsSqfl = resultsSqfl;
  }

  Future addItem(String name, String vicinity, double lat, double lng,
      String photo, BuildContext context) async {
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

  Future updateItem(int id, String name, String vicinity, double lat,
      double lng, String photo, BuildContext context) async {
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

  Future deleteItem(ResultsSqfl result, int index) async {
    _db.deleteResult(result.id).then(
      (_) {
        _resultsSqfl.removeAt(index);
        notifyListeners();
      },
    );
  }

  Future deleteData() async {
    _db.deleteData().then(
      (_) {
        getItems();
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
