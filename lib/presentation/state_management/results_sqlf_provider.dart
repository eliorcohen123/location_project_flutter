import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:locationprojectflutter/data/database/sqflite_helper.dart';
import 'package:locationprojectflutter/data/model/models_sqlf/ResultSql.dart';
import 'package:locationprojectflutter/presentation/pages/favorites_data.dart';

class ResultsSqlfProvider extends ChangeNotifier {
  final SQFLiteHelper _db = new SQFLiteHelper();

  Future addResult(String name, String vicinity, double lat, double lng,
      String photo, BuildContext context) async {
    var add = ResultSql.sqlf(name, vicinity, lat, lng, photo);
    _db.addResult(add).then((_) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavoritesData(),
          ));
    });
  }

  Future updateResult(int id, String name, String vicinity, double lat,
      double lng, String photo, BuildContext context) async {
    _db
        .updateResult(ResultSql.fromSqlf({
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
      ResultSql result, int index, List<ResultSql> _places) async {
    print(result.id);
    _db.deleteResult(result.id).then((_) {
      _places.removeAt(index);
      notifyListeners();
    });
  }

  Future deleteData(List<ResultSql> _places) async {
    _db.deleteData().then((_) {
      getItems(_places);
      notifyListeners();
    });
  }

  Future getItems(List<ResultSql> _places) async {
    _db.getAllResults().then((results) {
      _places.clear();
      results.forEach((result) {
        _places.add(ResultSql.fromSqlf(result));
      });
      notifyListeners();
    });
  }
}
