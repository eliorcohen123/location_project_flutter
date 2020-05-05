import 'dart:async';
import 'package:locationprojectflutter/data/models/models_sqlf/ResultSql.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQFLiteHelper {
  static final SQFLiteHelper _instance = new SQFLiteHelper.internal();

  factory SQFLiteHelper() => _instance;

  SQFLiteHelper.internal();

  final String tableResult = 'resultTable';
  final String columnId = 'id';
  final String columnName = 'name';
  final String columnVicinity = 'vicinity';
  final String columnLat = 'lat';
  final String columnLng = 'lng';
  final String columnPhoto = 'photo';

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    String path = join(await getDatabasesPath(), 'results.db');
    var db = await openDatabase(path, version: 1, onCreate: onCreate);
    return db;
  }

  void onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableResult($columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, $columnName TEXT, $columnVicinity TEXT, $columnLat REAL, $columnLng REAL, $columnPhoto TEXT)');
  }

  Future<int> addResult(ResultSql result) async {
    var dbClient = await db;
    var resultAdd = await dbClient.insert(tableResult, result.toSqlf());
    return resultAdd;
  }

  Future<int> updateResult(ResultSql result) async {
    var dbClient = await db;
    return await dbClient.update(tableResult, result.toSqlf(),
        where: "$columnId = ?", whereArgs: [result.id]);
  }

  Future<int> deleteResult(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableResult, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> deleteData() async {
    var dbClient = await db;
    return await dbClient.delete(tableResult);
  }

  Future<List> getAllResults() async {
    var dbClient = await db;
    var result = await dbClient.query(tableResult, columns: [
      columnId,
      columnName,
      columnVicinity,
      columnLat,
      columnLng,
      columnPhoto
    ]);
    return result.toList();
  }
}
