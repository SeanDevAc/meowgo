class Pokemon {
  final String name;
  final String url;
  final String imageUrl;
  final String type;
  final int unlocked;
  final int pokemonNumber;

  Pokemon({
    required this.name,
    required this.url,
    required this.imageUrl,
    required this.type,
    required this.unlocked,
    required this.pokemonNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
      'imageUrl': imageUrl,
      'type': type,
      'unlocked': unlocked,
      'pokemonNumber': pokemonNumber,
    };
  }
}
