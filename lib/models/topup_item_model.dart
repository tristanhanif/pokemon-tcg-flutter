class TopupItem {
  final String id;
  final String name;
  final int amount;
  final String icon;
  final String category; // 'coins', 'balls', 'items'

  TopupItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.icon,
    required this.category,
  });

  factory TopupItem.fromJson(Map<String, dynamic> json) {
    return TopupItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      amount: int.tryParse(json['amount'].toString()) ?? 0,
      icon: json['icon']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'icon': icon,
      'category': category,
    };
  }
}
