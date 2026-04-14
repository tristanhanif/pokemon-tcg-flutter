class PokemonSet {
  final String id;
  final String name;
  final String logo;
  final int price;
  final String description;

  PokemonSet({
    required this.id,
    required this.name,
    required this.logo,
    required this.price,
    required this.description,
  });

  factory PokemonSet.fromJson(Map<String, dynamic> json) {
    return PokemonSet(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Set',
      logo: json['logo']?.toString() ?? json['images']?['logo']?.toString() ?? 'https://via.placeholder.com/150',
      price: json['price'] != null ? int.tryParse(json['price'].toString()) ?? 0 : 0,
      description: json['description']?.toString() ?? 'No description available',
    );
  }
}
