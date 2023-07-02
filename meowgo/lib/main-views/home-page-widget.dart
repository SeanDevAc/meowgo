import 'package:flutter/material.dart';
import '../component/db_helper.dart';
import '../component/pokemonwidget.dart';
import '../component/pokemon.dart';
import './eggdex_page_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();

  static void setSelectedPokemon(Pokemon pokemon) {}
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  Future<Pokemon?> getActivePokemon() async {
    return await DatabaseHelper().getActivePokemon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            Center(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.height * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text(
                        'Active Pokemon: ',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                      Expanded(
                        flex: 1,
                        child: FractionallySizedBox(
                          widthFactor: 0.6,
                          heightFactor: 0.5,
                          child: FutureBuilder(
                            future: getActivePokemon(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text(
                                    'An error occured while loading the pokemon');
                              } else if (snapshot.hasData) {
                                return PokemonWidget(pokemon: snapshot.data!);
                              } else {
                                return Center(
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(255, 223, 71, 71),
                                        borderRadius: BorderRadius.circular(8.0),
                                        border: Border.all(color: Color.fromARGB(255, 182, 56, 47), width: 5.0),
                                      ),
                                      child: Text(
                                        'No pokemon is selected right now',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24.0,
                                        ),
                                      ),
                                    ),
                                  );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
