// ignore: depend_on_referenced_packages
// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'pokemon.dart';
import '../functionalities/egg_counter_widget.dart';

class DatabaseHelper {
  final _databaseName = 'pokemon_database1.db';
  final _databaseVersion = 2;

  final table = 'pokemon_table';
  final columnId = 'id';
  final columnName = 'name';
  final columnUrl = 'url';
  final columnImageUrl = 'imageUrl';
  final columnType = 'type';
  final columnUnlocked = 'unlocked';
  final columnPokemonNumber = 'pokemonNumber';

  final inventoryTable = 'inventory_table';
  final inventoryId = 'id';
  final inventoryDescription = 'description';
  final inventoryAmount = 'amount';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    // sqfliteFfiInit();
    // databaseFactory = databaseFactoryFfi;

    _database = await _initDatabase();
    return _database!;
  }

  Future<void> nukeDatabase() async {
    final db = await database;
    await db.delete(table);
    await db.delete(inventoryTable);
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, _databaseName);

    return await openDatabase(databasePath, version: _databaseVersion,
        onCreate: (db, version) async {
      _createDb(db);
    });
  }

  Future<void> insertPokemon(Pokemon pokemon) async {
    final db = await database;

    await db.insert(table, pokemon.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Pokemon>> getAllPokemon() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (index) {
      return Pokemon(
        name: maps[index][columnName],
        url: maps[index][columnUrl],
        imageUrl: maps[index][columnImageUrl],
        type: maps[index][columnType],
        unlocked: maps[index][columnUnlocked],
        pokemonNumber: maps[index][columnPokemonNumber],
      );
    });
  }

  Future<Pokemon> getPokemonByNumber(int pokemonNumber) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnPokemonNumber = ?',
      whereArgs: [pokemonNumber],
    );

    if (maps.isEmpty) {
      return Pokemon(
          name: 'name',
          url: 'url',
          imageUrl: 'imageUrl',
          pokemonNumber: 2,
          type: '',
          unlocked: 1);
    }

    return Pokemon(
      name: maps[0][columnName],
      url: maps[0][columnUrl],
      imageUrl: maps[0][columnImageUrl],
      type: maps[0][columnType],
      unlocked: maps[0][columnUnlocked],
      pokemonNumber: maps[0][columnPokemonNumber],
    );
  }

  Future<void> addEggs(int eggAmount) async {
    final db = await database;

    await db.execute('''
      UPDATE $inventoryTable 
      SET $inventoryAmount = $inventoryAmount + $eggAmount
      WHERE $inventoryId = 0;
''');
  }

  Future<int> getEggAmount() async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      inventoryTable,
      where: '$inventoryId = ?',
      whereArgs: [0],
    );

    if (maps.isEmpty) {
      await db.rawInsert('''
        INSERT INTO $inventoryTable(
          $inventoryId, $inventoryDescription, $inventoryAmount)
          VALUES(
            0, 'eggs', 0
          )

      ''');
      print('egg table added');
      return 0;
    }

    final amount = maps[0]['amount'] as int;
    print(amount);
    return amount;
  }

  void _createDb(Database db) async {
    final db = await database;
    await db.execute('''
          CREATE TABLE $inventoryTable (
            $inventoryId INTEGER PRIMARY KEY,
            $inventoryDescription TEXT,
            $inventoryAmount INTEGER
          )
          ''');
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT,
            $columnUrl TEXT,
            $columnImageUrl TEXT,
            $columnType TEXT,
            $columnUnlocked INTEGER,
            $columnPokemonNumber INTEGER
          )
        ''');
  }
}
