import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'pokemon.dart';

class PokemonDatabaseHelper {
  static const _databaseName = 'pokemon_database.db';
  static const _databaseVersion = 1;

  static const table = 'pokemon_table';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnUrl = 'url';
  static const columnImageUrl = 'imageUrl';
  static const columnType = 'type';
  static const columnUnlocked = 'unlocked';
  static const columnPokemonNumber = 'pokemonNumber';
  

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

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
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT,
            $columnUrl TEXT,
            $columnImageUrl TEXT,
            $columnType TEXT,
            $columnUnlocked INTEGER,
            $columnPokemonNumber INTEGER
          )
        ''');
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
        unlocked: maps[index][columnUnlocked] == 1,
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

    return Pokemon(
      name: maps[0][columnName],
      url: maps[0][columnUrl],
      imageUrl: maps[0][columnImageUrl],
      type: maps[0][columnType],
      unlocked: maps[0][columnUnlocked] == 1,
      pokemonNumber: maps[0][columnPokemonNumber],
    );
  }
}
