import 'package:flutter/material.dart';
import '../component/pokemon.dart';

class PokemonWidget extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonWidget({
    Key? key,
    required this.pokemon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = capitalizeFirstLetter(pokemon.name);
    final backgroundColor = getColorForType(pokemon.type);
    bool isPokemonLocked(Pokemon pokemon) {
      if (pokemon.unlocked == 0) {
        return false;
      } else {
        return true;
      }
    }

    final isLocked = isPokemonLocked(pokemon);

    return Container(
      color: backgroundColor,
      child: Visibility(
          visible: isLocked,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 2.0,
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  pokemon.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      '#${pokemon.pokemonNumber}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  String capitalizeFirstLetter(String text) {
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  Color getColorForType(String type) {
    switch (type) {
      case 'normal':
        return Colors.brown;
      case 'fire':
        return Colors.orange;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'flying':
        return Colors.cyan;
      case 'fighting':
        return Colors.red;
      case 'poison':
        return Colors.purple;
      case 'electric':
        return Colors.yellow;
      case 'ground':
        return Colors.brown;
      case 'rock':
        return Colors.grey;
      case 'psychic':
        return Colors.pink;
      case 'ice':
        return Colors.lightBlue;
      case 'bug':
        return Colors.lightGreen;
      case 'ghost':
        return Colors.indigo;
      case 'steel':
        return Colors.blueGrey;
      case 'dragon':
        return Colors.indigo;
      case 'dark':
        return Colors.black;
      case 'fairy':
        return Colors.pinkAccent;
      default:
        return Colors.grey;
    }
  }
}
