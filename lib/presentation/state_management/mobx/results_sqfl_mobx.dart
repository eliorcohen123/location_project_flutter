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
//  @observable
//  SQFLiteHelper _db = new SQFLiteHelper();
//  @observable
//  ObservableList<ResultSqfl> resultsSqfl = ObservableList.of([]);
//
//  @action
//  initList(ObservableList<ResultSqfl> resultsSqfl) {
//    this.resultsSqfl = resultsSqfl;
//  }
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
//  }
//
//  @action
//  Future deleteItem(ResultSqfl result, int index) async {
//    print(result.id);
//    _db.deleteResult(result.id).then((_) {
//      resultsSqfl.removeAt(index);
//    });
//  }
//
//  @action
//  Future deleteData() async {
//    _db.deleteData().then((_) {
//      getItems();
//    });
//  }
//
//  @action
//  Future getItems() async {
//    _db.getAllResults().then((results) {
//      resultsSqfl.clear();
//      results.forEach((result) {
//        resultsSqfl.add(ResultSqfl.fromSqfl(result));
//      });
//    });
//  }
//}
