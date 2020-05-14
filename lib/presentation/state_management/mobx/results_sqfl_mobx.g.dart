//// GENERATED CODE - DO NOT MODIFY BY HAND
//
//part of 'results_sqfl_mobx.dart';
//
//// **************************************************************************
//// StoreGenerator
//// **************************************************************************
//
//// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic
//
//mixin _$ResultsSqlfStore on _ResultsSqflBase, Store {
//  final _$_dbAtom = Atom(name: '_ResultsSqflBase._db');
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
//  final _$resultsSqflAtom = Atom(name: '_ResultsSqflBase.resultsSqfl');
//
//  @override
//  ObservableList<ResultSqfl> get resultsSqfl {
//    _$resultsSqflAtom.reportRead();
//    return super.resultsSqfl;
//  }
//
//  @override
//  set resultsSqfl(ObservableList<ResultSqfl> value) {
//    _$resultsSqflAtom.reportWrite(value, super.resultsSqfl, () {
//      super.resultsSqfl = value;
//    });
//  }
//
//  final _$addItemAsyncAction = AsyncAction('_ResultsSqflBase.addItem');
//
//  @override
//  Future<dynamic> addItem(String name, String vicinity, double lat, double lng,
//      String photo, BuildContext context) {
//    return _$addItemAsyncAction
//        .run(() => super.addItem(name, vicinity, lat, lng, photo, context));
//  }
//
//  final _$updateItemAsyncAction = AsyncAction('_ResultsSqflBase.updateItem');
//
//  @override
//  Future<dynamic> updateItem(int id, String name, String vicinity, double lat,
//      double lng, String photo, BuildContext context) {
//    return _$updateItemAsyncAction.run(
//        () => super.updateItem(id, name, vicinity, lat, lng, photo, context));
//  }
//
//  final _$deleteItemAsyncAction = AsyncAction('_ResultsSqflBase.deleteItem');
//
//  @override
//  Future<dynamic> deleteItem(ResultSqfl result, int index) {
//    return _$deleteItemAsyncAction.run(() => super.deleteItem(result, index));
//  }
//
//  final _$deleteDataAsyncAction = AsyncAction('_ResultsSqflBase.deleteData');
//
//  @override
//  Future<dynamic> deleteData() {
//    return _$deleteDataAsyncAction.run(() => super.deleteData());
//  }
//
//  final _$getItemsAsyncAction = AsyncAction('_ResultsSqflBase.getItems');
//
//  @override
//  Future<dynamic> getItems() {
//    return _$getItemsAsyncAction.run(() => super.getItems());
//  }
//
//  final _$_ResultsSqflBaseActionController =
//      ActionController(name: '_ResultsSqflBase');
//
//  @override
//  dynamic initList(ObservableList<ResultSqfl> resultsSqfl) {
//    final _$actionInfo = _$_ResultsSqflBaseActionController.startAction(
//        name: '_ResultsSqflBase.initList');
//    try {
//      return super.initList(resultsSqfl);
//    } finally {
//      _$_ResultsSqflBaseActionController.endAction(_$actionInfo);
//    }
//  }
//
//  @override
//  String toString() {
//    return '''
//resultsSqfl: ${resultsSqfl}
//    ''';
//  }
//}
