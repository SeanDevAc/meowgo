// import 'dart:convert';
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class pokemonAPI extends StatelessWidget {
//   const pokemonAPI({super.key})

//   State<pokemonAPI> createState() => loadAPI();

// }


// class loadAPI extends State<pokemonAPI> {
//   Future<List<Pokemon>> fetchData() async {
//     var url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=150');
//     var response = await http.get(url);

//     if (response.statusCode == 200) {
//       var data = json.decode(response.body);
//       List<dynamic> results = (data['results'] as List<dynamic>);

//       List<Pokemon> pokemonList = [];
//       for (var pokemon in results) {
//         var details = await fetchPokemonDetails(pokemon['url']);
//         pokemonList.add(Pokemon(
//           name: pokemon['name'],
//           url: pokemon['url'],
//           imageUrl: details['sprites']['front_default'],
//         ));
//       }

//       return pokemonList;
//     } else {
//       throw Exception('Failed to fetch data: ${response.statusCode}');
//     }
//   }

//   Future<Map<String, dynamic>> fetchPokemonDetails(String url) async {
//     var response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       return json.decode(response.body);
//     } else {
//       throw Exception(
//           'Failed to fetch Pokémon details: ${response.statusCode}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<Pokemon>>(
//       future: fetchData(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return const Center(child: Text('Failed to load data'));
//         } else {
//           final pokemonList = snapshot.data!;
//           final theme = Theme.of(context);
//           return Container(
//             color: theme.colorScheme.surface,
//             alignment: Alignment.center,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (pokemonList.isNotEmpty)
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: pokemonList.length,
//                       itemBuilder: (context, index) {
//                         var pokemon = pokemonList[index];
//                         return ListTile(
//                           title: Text(pokemon.name),
//                           leading: Image.network(pokemon.imageUrl),
//                         );
//                       },
//                     ),
//                   ),
//               ],
//             ),
//           );
//         }
//       },
//     );
//   }
// }

// class Pokemon {
//   final String name;
//   final String url;
//   final String imageUrl;

//   Pokemon({
//     required this.name,
//     required this.url,
//     required this.imageUrl,
//   });
// }
