class PokemonCard {
  final String id;
  final String name;
  final String imageUrl;
  final String imageUrlLarge;
  final List<String> types;
  final String hp;
  final String supertype;
  final String rarity;
  final String flavorText;

  PokemonCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.imageUrlLarge,
    required this.types,
    required this.hp,
    required this.supertype,
    required this.rarity,
    required this.flavorText,
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
    return PokemonCard(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      imageUrl: json['images']?['small'] ?? 'https://via.placeholder.com/240x330',
      imageUrlLarge: json['images']?['large'] ?? 'https://via.placeholder.com/500x700',
      types: (json['types'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? ['Colorless'],
      hp: json['hp'] ?? '0',
      supertype: json['supertype'] ?? 'Unknown',
      rarity: json['rarity'] ?? 'Common',
      flavorText: json['flavorText'] ?? 'A mysterious Pokémon.',
    );
  }
}
