import 'package:flutter/material.dart';
import 'package:meowgo/main-views/step_count_page.dart';
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
        title: const Text('New Pokemon!'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Gefeliciteerd!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Je hebt de volgende Pokémon ontgrendeld:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Expanded(
                  flex: 1,
                  child: FractionallySizedBox(
                    widthFactor: 0.5,
                    heightFactor: 0.5,
                    child: FutureBuilder(
                      future: getUnlockedPokemon(randomId()),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(
                              'An error occured while loading the pokemon');
                        } else if (snapshot.hasData) {
                          return PokemonWidget(pokemon: snapshot.data!);
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return StepCountPage();
                      },
                    ));
                  },
                  child: Text('Gather another egg!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
