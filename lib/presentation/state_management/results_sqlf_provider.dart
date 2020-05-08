import 'package:flutter/foundation.dart';
import 'package:locationprojectflutter/data/database/sqflite_helper.dart';
import 'package:locationprojectflutter/data/model/models_sqlf/ResultSql.dart';

class ResultsSqlfProvider extends ChangeNotifier {
  final SQFLiteHelper _db = new SQFLiteHelper();

  void deleteItem(ResultSql result, int index, List<ResultSql> _places) async {
    print(result.id);
    _db.deleteResult(result.id).then((_) {
      _places.removeAt(index);
      notifyListeners();
    });
  }

  void deleteData(List<ResultSql> _places) async {
    _db.deleteData().then((_) {
      getItems(_places);
      notifyListeners();
    });
  }

  void getItems(List<ResultSql> _places) async {
    _db.getAllResults().then((results) {
      _places.clear();
      results.forEach((result) {
        _places.add(ResultSql.fromSqlf(result));
      });
      notifyListeners();
    });
  }
}
