import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MenuDb {
  static final _databaseName = 'recipes_database.db';
  static final _databaseVersion = 1;
  static final table = 'recipes';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnImage = 'image';
  static final columnTotalTime = 'total_time';
  static final columnYield = 'yield';
  static final columnHealthLabels = 'health_labels';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    // Get the directory for the app's database
    final dbDir = await getDatabasesPath();
    final dbPath = join(dbDir, _databaseName);

    // Open/create the database at a given path
    return await openDatabase(dbPath, version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnImage TEXT NOT NULL,
        $columnTotalTime INTEGER NOT NULL,
        $columnYield INTEGER NOT NULL,
        $columnHealthLabels TEXT NOT NULL
      )
      ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final db = await database;
    return await db.query(table);
  }

  Future<int> update(Map<String, dynamic> row) async {
    final db = await database;
    final id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
