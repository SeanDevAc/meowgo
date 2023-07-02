import 'package:flutter/material.dart';
import '../component/db_helper.dart';
import '../component/pokemonwidget.dart';
import '../component/pokemon.dart';

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
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Active Pokemon: ',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  flex: 1,
                  child: FractionallySizedBox(
                    widthFactor: 0.75,
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
    );
  }
}