import 'dart:async';
import 'package:locationprojectflutter/data/models/model_sqfl/results_sqfl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQFLiteHelper {
  static final SQFLiteHelper _instance = SQFLiteHelper.internal();

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
    _db = await _initDb();
    return _db;
  }

  Future _initDb() async {
    String path = join(await getDatabasesPath(), 'results.db');
    var db = await openDatabase(path, version: 1, onCreate: onCreate);
    return db;
  }

  void onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableResult($columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, $columnName TEXT, $columnVicinity TEXT, $columnLat REAL, $columnLng REAL, $columnPhoto TEXT)');
  }

  Future<int> addResult(ResultsSqfl result) async {
    var dbClient = await db;
    return await dbClient.insert(
      tableResult,
      result.toSqfl(),
    );
  }

  Future<int> updateResult(ResultsSqfl result) async {
    var dbClient = await db;
    return await dbClient.update(tableResult, result.toSqfl(),
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
    var result = await dbClient.query(
      tableResult,
      columns: [
        columnId,
        columnName,
        columnVicinity,
        columnLat,
        columnLng,
        columnPhoto
      ],
    );
    return result.toList();
  }
}
