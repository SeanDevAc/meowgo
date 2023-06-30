import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StudyMonApp extends StatelessWidget {
  const StudyMonApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('EggDex'),
        ),
        body: const EggDexWidget(),
      ),
    );
  }
}

class EggDexWidget extends StatelessWidget {
  const EggDexWidget({
    Key? key,
  }) : super(key: key);

  Future<List<Pokemon>> fetchData() async {
    var url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=150');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> results = (data['results'] as List<dynamic>);

      List<Pokemon> pokemonList = [];
      for (int i = 0; i < results.length; i++) {
        var pokemon = results[i];
        var details = await fetchPokemonDetails(pokemon['url']);
        bool unlocked = (i < 10) ? false : true;

        pokemonList.add(Pokemon(
          name: pokemon['name'],
          url: pokemon['url'],
          imageUrl: details['sprites']['front_default'],
          type: details['types'][0]['type']['name'],
          unlocked: unlocked,
          pokemonNumber: i + 1,
        ));
      }

      return pokemonList;
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> fetchPokemonDetails(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to fetch Pokémon details: ${response.statusCode}');
    }
  }

  Color getTypeColor(String type) {
    switch (type) {
      case 'normal':
        return Colors.brown;
      case 'fire':
        return Colors.orange;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'flying':
        return Colors.cyan;
      case 'fighting':
        return Colors.red;
      case 'poison':
        return Colors.purple;
      case 'electric':
        return Colors.yellow;
      case 'ground':
        return Colors.brown;
      case 'rock':
        return Colors.grey;
      case 'psychic':
        return Colors.pink;
      case 'ice':
        return Colors.lightBlue;
      case 'bug':
        return Colors.lightGreen;
      case 'ghost':
        return Colors.indigo;
      case 'steel':
        return Colors.blueGrey;
      case 'dragon':
        return Colors.indigo;
      case 'dark':
        return Colors.black;
      case 'fairy':
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pokemon>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Failed to load data'));
        } else {
          //happyflow
          final pokemonList = snapshot.data!;
          return GridView.count(
            crossAxisCount: 2,
            children: pokemonList.map((pokemon) {
              final backgroundColor = getTypeColor(pokemon.type);
              final isUnlocked = pokemon.unlocked;

              return Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: isUnlocked ? backgroundColor : Colors.black,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: isUnlocked
                    ? PokemonWidget(pokemon: pokemon)
                    : LockedPokemonWidget(pokemon: pokemon),
              );
            }).toList(),
          );
        }
      },
    );
  }
}

class Pokemon {
  final String name;
  final String url;
  final String imageUrl;
  final String type;
  final bool unlocked;
  final int pokemonNumber;

  Pokemon({
    required this.name,
    required this.url,
    required this.imageUrl,
    required this.type,
    required this.unlocked,
    required this.pokemonNumber,
  });
}

class PokemonWidget extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonWidget({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2.0,
      child: Column(
        children: [
          Expanded(
            child: Image.network(
              pokemon.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  '#${pokemon.pokemonNumber}',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  pokemon.name,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LockedPokemonWidget extends StatelessWidget {
  final Pokemon pokemon;

  const LockedPokemonWidget({Key? key, required this.pokemon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.help_outline,
            size: 64.0,
            color: Colors.grey,
          ),
          const SizedBox(height: 8.0),
          Text(
            '#${pokemon.pokemonNumber}',
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4.0),
          const Text(
            'locked',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
