import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:locationprojectflutter/data/databases/sqflite_helper.dart';
import 'package:locationprojectflutter/data/models/model_sqfl/result_sqfl.dart';
import 'package:locationprojectflutter/presentation/pages/favorites_data.dart';

class ResultsSqflProvider extends ChangeNotifier {
  SQFLiteHelper _db = SQFLiteHelper();
  List<ResultSqfl> resultsSqfl = List();

  initList(List<ResultSqfl> resultsSqfl) {
    this.resultsSqfl = resultsSqfl;
  }

  Future addItem(String name, String vicinity, double lat, double lng,
      String photo, BuildContext context) async {
    var add = ResultSqfl.sqfl(name, vicinity, lat, lng, photo);
    _db.addResult(add).then((_) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavoritesData(),
          ));
      notifyListeners();
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
      notifyListeners();
    });
  }

  Future deleteItem(ResultSqfl result, int index) async {
    _db.deleteResult(result.id).then((_) {
      resultsSqfl.removeAt(index);
      notifyListeners();
    });
  }

  Future deleteData() async {
    _db.deleteData().then((_) {
      getItems();
      notifyListeners();
    });
  }

  Future getItems() async {
    _db.getAllResults().then((results) {
      resultsSqfl.clear();
      results.forEach((result) {
        resultsSqfl.add(ResultSqfl.fromSqfl(result));
        notifyListeners();
      });
    });
  }
}
