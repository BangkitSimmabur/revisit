import 'dart:developer' as developer;
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:revisit/db_helper/table_main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../db_helper/db_table.dart';

class DatabaseHelper {
  static final _databaseName = 'revisit raw.db';
  static final _databaseVersion = 6;

  DatabaseHelper();

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    print('creating db revisit');
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    print('creating db revisit2');

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    print('creating db revisit3');

    var db = await openDatabase(path);
    print('creating db revisit4');

    var dbCurrentVersion = await db.getVersion();
    print('creating db revisi5');

    print(dbCurrentVersion);
    print(_databaseVersion);
    if (dbCurrentVersion >= _databaseVersion) return db;

    print('creating db revisit6');

    /// If the version is mismatch
    /// Then do the syncing.
    db.close();
    print('creating db revisit6');


    await deleteDatabase(path);

    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    db = await openDatabase(
      path,
      onCreate: _onCreate,
      version: _databaseVersion,
    );

    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    // tables
    developer.log('CREATING TABLE');
    var batch = db.batch();
    developer.log(TableUser.tokenTableName);
    db.execute(DatabaseTable.TokenTable);
  }

  Future<int> createDb(
      String sql,
      ) async {
    var db = await instance.database;
    var batch = db.batch();
    batch.execute(sql);
    await batch.commit(noResult: true);

    return 1;
  }

  Future<int> insert(String tableName, Map<String, dynamic> row) async {
    var db = await instance.database;
    var batch = db.batch();

    batch.insert(tableName, row);
    await batch.commit(noResult: true);

    return 1;
  }

  Future<List<Map<String, dynamic>>> getList(String tableName) async {
    var db = await instance.database;
    return await db.query(tableName);
  }

  Future<Map<String, dynamic>> getFirst(String tableName) async {
    var db = await instance.database;
    var results = await db.rawQuery(
      'SELECT * FROM $tableName ORDER BY ID DESC',
    );

    if (results.length <= 0) {
      return null;
    }

    var tokenJson = Map<String, dynamic>.from(results[0]);
    return tokenJson;
  }

  Future<Map<String, dynamic>> getById(String tableName, int id) async {
    var db = await instance.database;
    var results = await db.rawQuery(tableName, [id]);

    if (results.length <= 0) return null;

    var firstResult = results[0];
    return firstResult;
  }

  Future<int> update(String tableName, Map<String, dynamic> row) async {
    var db = await instance.database;
    var batch = db.batch();

    var id = row[DatabaseTable.columnId];

    batch.update(
      tableName,
      row,
      where: '${DatabaseTable.columnId} = ?',
      whereArgs: [id],
    );

    await batch.commit(noResult: true);

    return 1;
  }

  Future<int> deleteAll(String tableName) async {
    var db = await instance.database;
    var batch = db.batch();

    batch.delete(tableName);
    await batch.commit(noResult: true);

    return 1;
  }

  Future<void> formatDb() async {
    var db = await instance.database;
    var batch = db.batch();

    try {
      batch.delete(DatabaseTable.TokenTable);
      await batch.commit(noResult: true);
      return 1;
    } catch (e) {
      developer.log(e?.message ?? 'Error in formatting db');
    }
  }

  Future<void> deleteDb() async {
    developer.log('Process deleting DB');

    var documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, _databaseName);
    final dir = Directory(path);
    dir.deleteSync(recursive: true);

    developer.log('Deleting DB done');
  }

  Future<void> closeDb() async {
    var db = await instance.database;
    await db.close();
    _database = null;
  }
}
