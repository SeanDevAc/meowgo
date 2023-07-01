import 'package:flutter/material.dart';
import '../component/db_helper.dart';
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
  List<Pokemon> allUnlockedPokemon = [];
  List<Pokemon> PartyList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUnlockedPokemon();
  }

  Future<void> fetchAllPokemon() async {
    final pokemonList = await DatabaseHelper().getAllPokemon();
    setState(() {
      allPokemonList = pokemonList;
      filteredPokemonList = pokemonList;
    });
  }

  Future<void> fetchUnlockedPokemon() async {
    final unlockedPokemonList = await DatabaseHelper().getUnlockedPokemon();
    setState(() {
      allUnlockedPokemon = unlockedPokemonList;
      filteredPokemonList = unlockedPokemonList;
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
    if (PartyList.length >= 4) {
      // Maximum limit reached, show an error message or handle accordingly
      return;
    }
    setState(() {
      PartyList.add(pokemon);
    });
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Added to Party'),
          content: const Text('Pokemon added to Party.'),
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
      PartyList.remove(pokemon);
    });
  }

  bool isPokemonSelected(Pokemon pokemon) {
    return PartyList.contains(pokemon);
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
