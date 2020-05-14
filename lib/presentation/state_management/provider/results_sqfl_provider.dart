import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:locationprojectflutter/data/databases/sqflite_helper.dart';
import 'package:locationprojectflutter/data/models/model_sqfl/ResultSqfl.dart';
import 'package:locationprojectflutter/presentation/pages/favorites_data.dart';

class ResultsSqflProvider extends ChangeNotifier {
  final SQFLiteHelper _db = new SQFLiteHelper();

  Future addItem(String name, String vicinity, double lat, double lng,
      String photo, BuildContext context) async {
    var add = ResultSqfl.sqfl(name, vicinity, lat, lng, photo);
    _db.addResult(add).then((_) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavoritesData(),
          ));
    });
  }

  Future updateItem(int id, String name, String vicinity, double lat,
      double lng, String photo, BuildContext context) async {
    _db
        .updateResult(ResultSqfl.fromSqfl({
      'id': id,
      'name': name,
      'vicinity': vicinity,
      'lat': lat,
      'lng': lng,
      'photo': photo
    }))
        .then((_) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavoritesData(),
          ));
    });
    ;
  }

  Future deleteItem(
      ResultSqfl result, int index, List<ResultSqfl> _places) async {
    print(result.id);
    _db.deleteResult(result.id).then((_) {
      _places.removeAt(index);
      notifyListeners();
    });
  }

  Future deleteData(List<ResultSqfl> _places) async {
    _db.deleteData().then((_) {
      getItems(_places);
      notifyListeners();
    });
  }

  Future getItems(List<ResultSqfl> _places) async {
    _db.getAllResults().then((results) {
      _places.clear();
      results.forEach((result) {
        _places.add(ResultSqfl.fromSqfl(result));
      });
      notifyListeners();
    });
  }
}
