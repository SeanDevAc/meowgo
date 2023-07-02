// ignore_for_file: depend_on_referenced_packages

import 'package:meowgo/functionalities/pokemonAPI-widget.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'pokemon.dart';

class DatabaseHelper {
  final _databaseName = 'pokemon_database6.db';
  final _databaseVersion = 1;

  final table = 'pokemon_table';
  final columnId = 'id';
  final columnName = 'name';
  final columnUrl = 'url';
  final columnImageUrl = 'imageUrl';
  final columnType = 'type';
  final columnUnlocked = 'unlocked';
  final columnPokemonNumber = 'pokemonNumber';
  final columnPokemonActive = 'pokemonActive';

//inventory:
// id 0 Eggs
// id 1 Steps
  final inventoryTable = 'inventory_table';
  final inventoryId = 'id';
  final inventoryDescription = 'description';
  final inventoryAmount = 'amount';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    // uncomment for windows support:
    //  sqfliteFfiInit();
    //  databaseFactory = databaseFactoryFfi;

    _database = await _initDatabase();
    return _database!;
  }

  Future<void> nukeDatabaseAndFill() async {
    final db = await database;
    await db.delete(table);
    await db.delete(inventoryTable);

    checkDatabaseEmptyAndFill();
  }

  Future<void> checkDatabaseEmptyAndFill() async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      table,
    );

    if (maps.isEmpty) {
      PokeApiWidget.fetchAllPokemon();
      return;
    }

    // print('database is already initialized');
    return;
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
        pokemonActive: maps[index][columnPokemonActive],
      );
    });
  }

  Future<List<Pokemon>> getUnlockedPokemon() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(table, where: '$columnUnlocked = ?', whereArgs: [1]);

    return List.generate(maps.length, (index) {
      return Pokemon(
        name: maps[index][columnName],
        url: maps[index][columnUrl],
        imageUrl: maps[index][columnImageUrl],
        type: maps[index][columnType],
        unlocked: maps[index][columnUnlocked],
        pokemonNumber: maps[index][columnPokemonNumber],
        pokemonActive: maps[index][columnPokemonActive],
      );
    });
  }

  Future<Pokemon?> getActivePokemon() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnUnlocked = ? AND $columnPokemonActive = ?',
      whereArgs: [1, 1],
      limit: 1,
    );

    if (maps.isNotEmpty) {
      final Map<String, dynamic> pokemonMap = maps.first;
      return Pokemon(
        name: pokemonMap[columnName],
        url: pokemonMap[columnUrl],
        imageUrl: pokemonMap[columnImageUrl],
        type: pokemonMap[columnType],
        unlocked: pokemonMap[columnUnlocked],
        pokemonNumber: pokemonMap[columnPokemonNumber],
        pokemonActive: pokemonMap[columnPokemonActive],
      );
    }

    return null; // Return null if no active Pokemon is found
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
          unlocked: 1,
          pokemonActive: 0);
    }

    return Pokemon(
      name: maps[0][columnName],
      url: maps[0][columnUrl],
      imageUrl: maps[0][columnImageUrl],
      type: maps[0][columnType],
      unlocked: maps[0][columnUnlocked],
      pokemonNumber: maps[0][columnPokemonNumber],
      pokemonActive: maps[0][columnPokemonActive],
    );
  }

  Future<void> addEggs(int eggAmount) async {
    final db = await database;
    print('added eggs: $eggAmount');

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
      // print('egg table added');
      return 0;
    }

    final amount = maps[0]['amount'] as int;
    return amount;
  }

  Future<int> getStepsAmount() async {
    final db = await database;
    final List<Map<String, Object?>> maps = await db.query(
      inventoryTable,
      where: '$inventoryId = ?',
      whereArgs: [1],
    );

    if (maps.isEmpty) {
      await db.rawInsert('''
        INSERT INTO $inventoryTable(
          $inventoryId, $inventoryDescription, $inventoryAmount)
          VALUES(
            1, 'steps', 0
          )

      ''');
      print('steps table added');
      return 0;
    }

    final amount = maps[0]['amount'] as int;
    print(amount);
    return amount;
  }

  Future<void> setStepsAmount(int stepsAmount) async {
    final db = await database;

    await db.execute('''
      UPDATE $inventoryTable 
      SET $inventoryAmount = $stepsAmount
      WHERE $inventoryId = 1;
''');
  }

  Future<int> updatePokemonUnlocked(int unlockedPokemon) async {
    final db = await database;

    await db.execute('''
      UPDATE $table 
      SET $columnUnlocked = 1
      WHERE $columnPokemonNumber = $unlockedPokemon;
    ''');

    print('Pokemon unlocked updated successfully: $unlockedPokemon');
    return unlockedPokemon;
  }

  Future<int> updatePokemonActive(int PokemonId, int updatedStatus) async {
    final db = await database;

    await db.execute('''
      UPDATE $table 
      SET $columnPokemonActive = $updatedStatus
      WHERE $columnPokemonNumber = $PokemonId;
    ''');

    print('Pokemon Active updated successfully: $PokemonId');
    return PokemonId;
  }

  Future<void> resetPokemonActive() async {
    final db = await database;

    await db.execute('''
      UPDATE $table 
      SET $columnPokemonActive = 0
    ''');

    print('reset pokemonActive status');
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
            $columnPokemonNumber INTEGER,
            $columnPokemonActive INTEGER
          )
        ''');
  }
}
