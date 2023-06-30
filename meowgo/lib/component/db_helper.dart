import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:meowgo/component/pokemon_db_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'pokemon.dart';

class DatabaseHelper {
  final _databaseName = 'pokemon_database.db';
  final _databaseVersion = 1;

  final table = 'inventory_table';
  final id = 'id';
  final description = 'description';
  final amount = 'amount';

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
    PokemonDatabaseHelper().addEggs(eggAmount);
  }

  Future<int> getEggAmount() async {
    // final db = await database;
    // final List<Map<String, Object?>> maps = await db.query(
    //   table,
    //   where: '$id = ?',
    //   whereArgs: [0],
    // );

    // final amount = maps[0]['amount'] as int;

    return PokemonDatabaseHelper().getEggAmount();
  }
}
