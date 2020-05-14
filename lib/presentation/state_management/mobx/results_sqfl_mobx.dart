//import 'package:flutter/material.dart';
//import 'package:locationprojectflutter/data/databases/sqflite_helper.dart';
//import 'package:locationprojectflutter/data/models/model_sqfl/ResultSqfl.dart';
//import 'package:locationprojectflutter/presentation/pages/favorites_data.dart';
//import 'package:mobx/mobx.dart';
//
//part 'results_sqfl_mobx.g.dart';
//
//class ResultsSqlfStore = _ResultsSqflBase with _$ResultsSqlfStore;
//
//abstract class _ResultsSqflBase with Store {
//  SQFLiteHelper _db = new SQFLiteHelper();
//
//  @action
//  Future addItem(String name, String vicinity, double lat, double lng,
//      String photo, BuildContext context) async {
//    var add = ResultSqfl.sqfl(name, vicinity, lat, lng, photo);
//    _db.addResult(add).then((_) {
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) => FavoritesData(),
//          ));
//    });
//  }
//
//  @action
//  Future updateItem(int id, String name, String vicinity, double lat,
//      double lng, String photo, BuildContext context) async {
//    _db
//        .updateResult(ResultSqfl.fromSqfl({
//      'id': id,
//      'name': name,
//      'vicinity': vicinity,
//      'lat': lat,
//      'lng': lng,
//      'photo': photo
//    }))
//        .then((_) {
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) => FavoritesData(),
//          ));
//    });
//    ;
//  }
//
//  @action
//  Future deleteItem(
//      ResultSqfl result, int index, List<ResultSqfl> _places) async {
//    print(result.id);
//    _db.deleteResult(result.id).then((_) {
//      _places.removeAt(index);
//    });
//  }
//
//  @action
//  Future deleteData(List<ResultSqfl> _places) async {
//    _db.deleteData().then((_) {
//      getItems(_places);
//    });
//  }
//
//  @action
//  Future getItems(List<ResultSqfl> _places) async {
//    _db.getAllResults().then((results) {
//      _places.clear();
//      results.forEach((result) {
//        _places.add(ResultSqfl.fromSqfl(result));
//      });
//    });
//  }
//}
