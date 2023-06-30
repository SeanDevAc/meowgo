import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'pokemon.dart';

class DatabaseHelper {
  static const _databaseName = 'pokemon_database.db';
  static const _databaseVersion = 1;

  static const table = 'inventory_table';
  static const id = 'id';
  static const description = 'description';
  static const amount = 'amount';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<void> nukeDatabase() async {
    final db = await database;
    await db.delete(table);
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, _databaseName);

    return await openDatabase(databasePath, version: _databaseVersion,
        onCreate: (db, version) {
      return db.execute('''
          CREATE TABLE $table (
            $id INTEGER PRIMARY KEY,
            $description TEXT,
            $amount INTEGER
          )
        ''');
    });
  }

  Future<void> addEggs(int eggAmount) async {
    final db = await database;

    await db.execute('''
      UPDATE $table 
      SET $amount = $amount + $eggAmount
      WHERE $id = 0
''');
  }

  Future<int> getEggAmount() async {
    final db = await database;
    Future<List<Map<String, Object?>>> _result = db.rawQuery('''
      SELECT $amount 
      FROM $table
      WHERE $id = 0
''');
    return 2;
  }
}
