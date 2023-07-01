import 'package:flutter/material.dart';
import '../component/db_helper.dart';
import '../component/pokemonwidget.dart';
import '../component/pokemon.dart';
import 'dart:math';

class gotNewPokemonPage extends StatelessWidget {
  const gotNewPokemonPage({
    super.key,
  });

  Future<List<Pokemon>> _loadPokemonList() async {
    return await DatabaseHelper().getAllPokemon();
  }

  Future<Pokemon> getUnlockedPokemon(int pokemonId) async {
    DatabaseHelper().updatePokemonUnlocked(pokemonId);
    return DatabaseHelper().getPokemonByNumber(pokemonId);
  }

  int randomId() {
    int unlockedPokemonId = Random().nextInt(151);
    return unlockedPokemonId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Pokemon Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: 1000,
            width: 1000,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Gefeliciteerd!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  'Je hebt de volgende Pokémon ontgrendeld:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Expanded(
                  flex: 1,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 0.5,
                    child: FutureBuilder(
                      future: getUnlockedPokemon(randomId()),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Er is een fout opgetreden bij het laden van de Pokémon.');
                        } else if (snapshot.hasData) {
                          return PokemonWidget(pokemon: snapshot.data!);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
