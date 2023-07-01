import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import '../component/db_helper.dart';
import '../component/pokemonwidget.dart';
import '../component/pokemon.dart';
import '../functionalities/pokemonAPI-widget.dart';
import './eggdex_page_widget.dart';
import '../functionalities/egg_counter_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<int> getEggAmount() async {
    return await DatabaseHelper().getEggAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: ElevatedButton(
              onPressed: () => DatabaseHelper().addEggs(1),
              style: const ButtonStyle(),
              child: FutureBuilder(
                  future: DatabaseHelper().getEggAmount(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text('${snapshot.data}');
                    } else {
                      return const Text('0');
                    }
                  })
              //PokemonDatabaseHelper().getPokemonByNumber(1)
              ),
        ),
        SizedBox(height: 400, child: partyPokemonList()),
      ],
    );
  }

  FutureBuilder<List<Pokemon>> partyPokemonList() {
    return FutureBuilder<List<Pokemon>>(
      future: fetchRandomPokemon(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Failed to load data'));
        } else {
          final pokemonList = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: pokemonList.length,
            itemBuilder: (context, index) {
              final pokemon = pokemonList[index];
              return Container(
                margin: const EdgeInsets.all(8.0),
                child: PokemonWidget(pokemon: pokemon),
              );
            },
          );
        }
      },
    );
  }

  Future<List<Pokemon>> fetchRandomPokemon() async {
    final List<Pokemon> randomPokemonList = [];

    while (randomPokemonList.length < 4) {
      final randomPokemonNumber = generateRandomNumber(20);
      final pokemon =
          await PokeApiWidget.fetchPokemonByNumber(randomPokemonNumber);

      randomPokemonList.add(pokemon);
    }

    return randomPokemonList;
  }

  int generateRandomNumber(int max) {
    final random = Random();
    return random.nextInt(max) + 1;
  }
}
