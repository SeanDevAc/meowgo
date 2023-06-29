// import 'package:flutter/foundation.dart';

// class PokemonManager extends ChangeNotifier {
//   List<Pokemon> _pokemonList = []; // Lijst met Pokémon-gegevens

//   List<Pokemon> get pokemonList => _pokemonList;

//   // Functie om de ontgrendelde status van een specifiek nummer van een Pokémon te schakelen
//   void togglePokemonUnlockedStatus(int pokemonNumber) {
//     final pokemonIndex = _pokemonList
//         .indexWhere((pokemon) => pokemon.pokemonNumber == pokemonNumber);

//     if (pokemonIndex != -1) {
//       _pokemonList[pokemonIndex] = _pokemonList[pokemonIndex].copyWith(
//         unlocked: !_pokemonList[pokemonIndex].unlocked,
//       );
//       notifyListeners();
//     }
//   }
// }

// extension PokemonExtension on Pokemon {
//   Pokemon copyWith({
//     String? name,
//     String? url,
//     String? imageUrl,
//     String? type,
//     bool? unlocked,
//     int? pokemonNumber,
//   }) {
//     return Pokemon(
//       name: name ?? this.name,
//       url: url ?? this.url,
//       imageUrl: imageUrl ?? this.imageUrl,
//       type: type ?? this.type,
//       unlocked: unlocked ?? this.unlocked,
//       pokemonNumber: pokemonNumber ?? this.pokemonNumber,
//     );
//   }
// }
