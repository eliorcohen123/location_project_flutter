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
//  Future<dynamic> deleteItem(
//      ResultSqfl result, int index, List<ResultSqfl> _places) {
//    return _$deleteItemAsyncAction
//        .run(() => super.deleteItem(result, index, _places));
//  }
//
//  final _$deleteDataAsyncAction = AsyncAction('_ResultsSqflBase.deleteData');
//
//  @override
//  Future<dynamic> deleteData(List<ResultSqfl> _places) {
//    return _$deleteDataAsyncAction.run(() => super.deleteData(_places));
//  }
//
//  final _$getItemsAsyncAction = AsyncAction('_ResultsSqflBase.getItems');
//
//  @override
//  Future<dynamic> getItems(List<ResultSqfl> _places) {
//    return _$getItemsAsyncAction.run(() => super.getItems(_places));
//  }
//
//  @override
//  String toString() {
//    return '''
//
//    ''';
//  }
//}
