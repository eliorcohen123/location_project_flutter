//// GENERATED CODE - DO NOT MODIFY BY HAND
//
//part of 'results_data_mobx.dart';
//
//// **************************************************************************
//// StoreGenerator
//// **************************************************************************
//
//// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic
//
//mixin _$ResultsDataMobXStore on _ResultsDataBase, Store {
//  final _$_dbAtom = Atom(name: '_ResultsDataBase._db');
//
//  @override
//  SQFLiteHelper get _db {
//    _$_dbAtom.reportRead();
//    return super._db;
//  }
//
//  @override
//  set _db(SQFLiteHelper value) {
//    _$_dbAtom.reportWrite(value, super._db, () {
//      super._db = value;
//    });
//  }
//
//  final _$_resultsSqflAtom = Atom(name: '_ResultsDataBase._resultsSqfl');
//
//  @override
//  ObservableList<ResultsSqfl> get _resultsSqfl {
//    _$_resultsSqflAtom.reportRead();
//    return super._resultsSqfl;
//  }
//
//  @override
//  set _resultsSqfl(ObservableList<ResultsSqfl> value) {
//    _$_resultsSqflAtom.reportWrite(value, super._resultsSqfl, () {
//      super._resultsSqfl = value;
//    });
//  }
//
//  final _$_locationRepoImplAtom =
//      Atom(name: '_ResultsDataBase._locationRepoImpl');
//
//  final _$_ResultsDataBaseActionController =
//      ActionController(name: '_ResultsDataBase');
//
//  @override
//  void initList(ObservableList<ResultsSqfl> resultsSqfl) {
//    final _$actionInfo = _$_ResultsDataBaseActionController.startAction(
//        name: '_ResultsDataBase.initList');
//    try {
//      return super.initList(resultsSqfl);
//    } finally {
//      _$_ResultsDataBaseActionController.endAction(_$actionInfo);
//    }
//  }
//
//  @override
//  void addItem(String name, String vicinity, double lat, double lng,
//      String photo, BuildContext context) {
//    final _$actionInfo = _$_ResultsDataBaseActionController.startAction(
//        name: '_ResultsDataBase.addItem');
//    try {
//      return super.addItem(name, vicinity, lat, lng, photo, context);
//    } finally {
//      _$_ResultsDataBaseActionController.endAction(_$actionInfo);
//    }
//  }
//
//  @override
//  void updateItem(int id, String name, String vicinity, double lat, double lng,
//      String photo, BuildContext context) {
//    final _$actionInfo = _$_ResultsDataBaseActionController.startAction(
//        name: '_ResultsDataBase.updateItem');
//    try {
//      return super.updateItem(id, name, vicinity, lat, lng, photo, context);
//    } finally {
//      _$_ResultsDataBaseActionController.endAction(_$actionInfo);
//    }
//  }
//
//  @override
//  void deleteItem(ResultsSqfl result, int index) {
//    final _$actionInfo = _$_ResultsDataBaseActionController.startAction(
//        name: '_ResultsDataBase.deleteItem');
//    try {
//      return super.deleteItem(result, index);
//    } finally {
//      _$_ResultsDataBaseActionController.endAction(_$actionInfo);
//    }
//  }
//
//  @override
//  void deleteData() {
//    final _$actionInfo = _$_ResultsDataBaseActionController.startAction(
//        name: '_ResultsDataBase.deleteData');
//    try {
//      return super.deleteData();
//    } finally {
//      _$_ResultsDataBaseActionController.endAction(_$actionInfo);
//    }
//  }
//
//  @override
//  void getItems() {
//    final _$actionInfo = _$_ResultsDataBaseActionController.startAction(
//        name: '_ResultsDataBase.getItems');
//    try {
//      return super.getItems();
//    } finally {
//      _$_ResultsDataBaseActionController.endAction(_$actionInfo);
//    }
//  }
//
//  @override
//  String toString() {
//    return '''
//
//    ''';
//  }
//}
