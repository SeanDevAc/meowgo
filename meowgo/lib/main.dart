// import 'dart:ffi';
import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const StudyMonApp());
}

class StudyMonApp extends StatelessWidget {
  const StudyMonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(174, 255, 15, 15))),
      home: const StudyMonStatefulWidget(),
    );
  }
}

class StudyMonStatefulWidget extends StatefulWidget {
  const StudyMonStatefulWidget({super.key});

  @override
  State<StudyMonStatefulWidget> createState() => _StudyMonState();
}

class _StudyMonState extends State<StudyMonStatefulWidget> {
  int currentPageIndex = 0;
  var pages = <Text>[
    const Text("Current session"),
    const Text("Egg-Dex"),
    const Text("Settings & Stats"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: pages[currentPageIndex],
        // backgroundColor: ,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.egg),
            label: 'Egg-Dex',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Stats',
          ),
        ],
      ),
      body: <Widget>[
        const HomePageWidget(),
        const EggDexWidget(),
        const SettingsStatsWidget(),
      ][currentPageIndex],
    );
  }
}

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.inversePrimary,
      alignment: Alignment.center,
      child: const Text('Page 1'),
    );
  }
}

class EggDexWidget extends StatelessWidget {

    const EggDexWidget({
    super.key,
    });

  Future<List<Pokemon>> fetchData() async {
    var url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=150');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> results = (data['results'] as List<dynamic>);

      List<Pokemon> pokemonList = [];
      for (var pokemon in results) {
        var details = await fetchPokemonDetails(pokemon['url']);
        pokemonList.add(Pokemon(
          name: pokemon['name'],
          url: pokemon['url'],
          imageUrl: details['sprites']['front_default'],
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
      throw Exception('Failed to fetch Pokémon details: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Pokemon>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load data'));
        } else {
          final pokemonList = snapshot.data!;
          final theme = Theme.of(context);
          return Container(
            color: theme.colorScheme.surface,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (pokemonList.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: pokemonList.length,
                      itemBuilder: (context, index) {
                        var pokemon = pokemonList[index];
                        return ListTile(
                          title: Text(pokemon.name),
                          leading: Image.network(pokemon.imageUrl),
                        );
                      },
                    ),
                  ),
              ],
            ),
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

  Pokemon({
    required this.name,
    required this.url,
    required this.imageUrl,
  });
}

class SettingsStatsWidget extends StatelessWidget {
  const SettingsStatsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.inversePrimary,
      alignment: Alignment.center,
      child: const Text('Page 3'),
    );
  }
}
