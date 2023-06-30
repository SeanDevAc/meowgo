import 'package:flutter/material.dart';
import '../component/pokemon_db_helper.dart';
import '../component/pokemonwidget.dart';
import '../component/pokemon.dart';
// import '../functionalities/pokemonAPI-widget.dart';

class EggDexWidget extends StatefulWidget {
  const EggDexWidget({Key? key}) : super(key: key);

  @override
  State<EggDexWidget> createState() => _EggDexWidgetState();
}

class _EggDexWidgetState extends State<EggDexWidget> {
  List<Pokemon> allPokemonList = [];
  List<Pokemon> filteredPokemonList = [];
  List<Pokemon> activePokemonList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAllPokemon();
  }

  Future<void> fetchAllPokemon() async {
    final pokemonList = await PokemonDatabaseHelper().getAllPokemon();
    setState(() {
      allPokemonList = pokemonList;
      filteredPokemonList = pokemonList;
    });
  }

  // Future<void> fetchAllPokemo() async {
  //   final pokemonList = await PokeApiWidget.fetchAllPokemon();
  //   setState(() {
  //     allPokemonList = pokemonList;
  //     filteredPokemonList = pokemonList;
  //   });
  // }

  void filterPokemon(String searchQuery) {
    if (searchQuery.isEmpty) {
      setState(() {
        filteredPokemonList = allPokemonList;
      });
    } else {
      final List<Pokemon> filteredList = [];
      for (final pokemon in allPokemonList) {
        if (pokemon.name.toLowerCase().contains(searchQuery.toLowerCase())) {
          filteredList.add(pokemon);
        }
      }
      setState(() {
        filteredPokemonList = filteredList;
      });
    }
  }

  void addToInventory(Pokemon pokemon) {
    if (activePokemonList.length >= 4) {
      // Maximum limit reached, show an error message or handle accordingly
      return;
    }
    setState(() {
      activePokemonList.add(pokemon);
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pokemon Added'),
          content: const Text('Pokemon added to inventory.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void removeFromInventory(Pokemon pokemon) {
    setState(() {
      activePokemonList.remove(pokemon);
    });
  }

  bool isPokemonSelected(Pokemon pokemon) {
    return activePokemonList.contains(pokemon);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            onChanged: filterPokemon,
            decoration: const InputDecoration(
              labelText: 'Search Pokémon',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: filteredPokemonList.length,
            itemBuilder: (context, index) {
              final pokemon = filteredPokemonList[index];
              final isSelected = isPokemonSelected(pokemon);
              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    removeFromInventory(pokemon);
                  } else {
                    addToInventory(pokemon);
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      width: 2000,
                      margin: const EdgeInsets.all(8.0),
                      child: PokemonWidget(pokemon: pokemon),
                    ),
                    if (isSelected)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black54,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.check,
                            size: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
