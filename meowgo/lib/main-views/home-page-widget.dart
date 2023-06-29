import 'dart:math';
import 'package:flutter/material.dart';
import '../component/pokemon_db_helper.dart';
import '../component/pokemonwidget.dart';
import '../component/pokemon.dart';
import '../functionalities/pokemonAPI-widget.dart';
import './eggdex_page_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Pokemon>>(
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
      ),
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
