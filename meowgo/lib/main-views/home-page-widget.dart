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
                      const Text(
                        'Active Pokemon: ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
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
                                return Text(
                                    'An error occured while loading the pokemon');
                              } else if (snapshot.hasData) {
                                return PokemonWidget(pokemon: snapshot.data!);
                              } else {
                                return Text('No pokemon is following you');
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
