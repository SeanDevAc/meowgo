import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:meowgo/pokemon_helpers/db_helper.dart';
import 'pokemon.dart';

class PokemonApi {
  static Future<List<Pokemon>> fetchAllPokemon() async {
    var url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1000');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<dynamic> results = data['results'];

      List<Pokemon> pokemonList = [];
      for (int i = 0; i < results.length; i++) {
        var pokemon = results[i];
        var details = await fetchPokemonDetails(pokemon['url']);

        pokemon = Pokemon(
          name: pokemon['name'],
          url: pokemon['url'],
          imageUrl: details['sprites']['front_default'],
          type: details['types'][0]['type']['name'],
          unlocked: i == 6 ? 1 : 0,
          pokemonNumber: i + 1,
          pokemonActive: 0,
        );

        DatabaseHelper().insertPokemon(pokemon);
        pokemonList.add(pokemon);
      }

      return pokemonList;
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> fetchPokemonDetails(String url) async {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  }
}
