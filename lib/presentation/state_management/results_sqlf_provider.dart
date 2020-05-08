import 'package:flutter/foundation.dart';
import 'package:locationprojectflutter/data/database/sqflite_helper.dart';
import 'package:locationprojectflutter/data/model/models_sqlf/ResultSql.dart';

class ResultsSqlfProvider extends ChangeNotifier {
  final SQFLiteHelper _db = new SQFLiteHelper();

  Future addResult(String name, String vicinity, double lat, double lng,
      String photo) async {
    var add = ResultSql.sqlf(name, vicinity, lat, lng, photo);
    _db.addResult(add);
  }

  Future updateResult(int id, String name, String vicinity, double lat,
      double lng, String photo) async {
    _db.updateResult(ResultSql.fromSqlf({
      'id': id,
      'name': name,
      'vicinity': vicinity,
      'lat': lat,
      'lng': lng,
      'photo': photo
    }));
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
