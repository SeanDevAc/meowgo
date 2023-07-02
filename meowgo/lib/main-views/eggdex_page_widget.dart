import 'package:flutter/material.dart';
import 'package:meowgo/main-views/home-page-widget.dart';
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
  List<Pokemon> partyList = [];
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
      allPokemonList = unlockedPokemonList;
      filteredPokemonList = unlockedPokemonList;
    });
  }

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

  Future<Pokemon> toggleActivePokemon(int pokemonId, int pokemonStatus) async {
    DatabaseHelper().resetPokemonActive();
    DatabaseHelper().updatePokemonActive(pokemonId, pokemonStatus);
    return DatabaseHelper().getPokemonByNumber(pokemonId);
  }

  void addToInventory(Pokemon pokemon) {
    if (partyList.length >= 1) {
      return;
    }
    setState(() {
      partyList.add(pokemon);
    });
    toggleActivePokemon(pokemon.getPokemonNumber(), 1);
    print('Pokemon $pokemon Selected');
  }

  void removeFromInventory(Pokemon pokemon) {
    setState(() {
      partyList.remove(pokemon);
    });
    toggleActivePokemon(pokemon.getPokemonNumber(), 0);
  }

  bool isPokemonSelected(Pokemon pokemon) {
    return partyList.contains(pokemon);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.red, // Change the color here
            Colors.red, // Change the color here
            Colors.white, // Change the color here
            Colors.white, // Change the color here
          ],
          stops: [0.0, 0.5, 0.5, 1.0],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 6.0,
            color: Colors.black,
          ),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2.0),
            ),
          ),
          Column(
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
                                child: const Text(
                                  'Pokemon added to party',
                                  style: TextStyle(
                                    color: Colors.white, // Change the color here
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
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
          ),
        ],
      ),
    );
  }
}
