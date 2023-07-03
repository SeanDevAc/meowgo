import 'package:flutter/material.dart';
import '../pokemon_helpers/db_helper.dart';
import '../pokemon_helpers/pokemon_widget.dart';
import '../pokemon_helpers/pokemon.dart';

class DexWidget extends StatefulWidget {
  const DexWidget({Key? key}) : super(key: key);

  @override
  State<DexWidget> createState() => _DexWidgetState();
}

class _DexWidgetState extends State<DexWidget> {
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
    if (partyList.isNotEmpty) {
      return;
    }
    setState(() {
      partyList.add(pokemon);
    });
    toggleActivePokemon(pokemon.getPokemonNumber(), 1);
    // print('Pokemon $pokemon Selected');
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

  Future<void> _refreshPage() async {
    await fetchUnlockedPokemon();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
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
            height: 20.0,
            color: Colors.black,
          ),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 20.0),
            ),
          ),
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.red.shade50, // Change the color here
              shape: BoxShape.circle,
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5.0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: filterPokemon,
                    decoration: const InputDecoration(
                      labelText: 'Search Pokémon',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Expanded(
                  child: NotificationListener<OverscrollNotification>(
                    onNotification: (OverscrollNotification notification) {
                      if (notification.overscroll < 0 &&
                          notification.metrics.atEdge) {
                        _refreshPage();
                        return true;
                      }
                      return false;
                    },
                    child: RefreshIndicator(
                      onRefresh: _refreshPage,
                      child: Stack(
                        children: [
                          GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
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
                                            'Selected',
                                            style: TextStyle(
                                              color: Colors.white,
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
                        ],
                      ),
                    ),
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
