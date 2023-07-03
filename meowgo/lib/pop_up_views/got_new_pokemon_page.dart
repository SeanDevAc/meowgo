import 'package:flutter/material.dart';
import '../pokemon_helpers/db_helper.dart';
import '../pokemon_helpers/pokemon_widget.dart';
import '../pokemon_helpers/pokemon.dart';
import 'dart:math';

class GotNewPokemonPage extends StatefulWidget {
  const GotNewPokemonPage({
    super.key,
  });

  @override
  State<GotNewPokemonPage> createState() => _GotNewPokemonPageState();
}

class _GotNewPokemonPageState extends State<GotNewPokemonPage> {
  int totalSteps = 0;
  int unlockedPokemonId = 0;
  bool isFirstLoad = true;

  Future<Pokemon> getUnlockedPokemon(int pokemonId) async {
    DatabaseHelper().updatePokemonUnlocked(pokemonId);
    return DatabaseHelper().getPokemonByNumber(pokemonId);
  }

  void setRandomId() {
    if (isFirstLoad) {
      setState(() {
        unlockedPokemonId = Random().nextInt(1000);
      });
      isFirstLoad = false;
    }
  }

  void openStepCounter() async {
    await Navigator.pushNamed(
      context,
      '/stepCountPage',
    );
  }

  @override
  Widget build(BuildContext context) {
    setRandomId();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Pokemon!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 41, 42, 42),
        leading: const BackButton(
          style: ButtonStyle(
              iconColor: MaterialStatePropertyAll<Color>(Colors.white)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Colors.white,
              Colors.white,
              Colors.yellow.withOpacity(1.0),
            ],
            stops: const [0.0, 0.2, 1.0],
            center: Alignment.center,
            radius: 1.0,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Congratulations!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'You hatched a new Pokémon!:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    flex: 1,
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      heightFactor: 0.5,
                      child: FutureBuilder(
                        future: getUnlockedPokemon(unlockedPokemonId),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text(
                                'An error occurred while loading the pokemon');
                          } else if (snapshot.hasData) {
                            return PokemonWidget(pokemon: snapshot.data!);
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      openStepCounter();
                    },
                    child: const Text('Take a walk for a bonus egg!'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
