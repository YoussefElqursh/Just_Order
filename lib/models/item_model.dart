class Item {
  String itemId;
  double price;
  double discount;
  String imageUrl;
  bool available;
  String name;
  String description;
  String type;
  String category;
  Map<String, double>? sizes;
  Map<String, double>? extras;

  Item({
    required this.itemId,
    required this.price,
    required this.discount,
    required this.imageUrl,
    required this.available,
    required this.name,
    required this.description,
    required this.type,
    required this.category,
    this.sizes,
    this.extras,
  });

  static Item fromMap(Map<String, dynamic> item) {
    return Item(
      itemId: item['itemId'],
      price: (item['price'] as num).toDouble(),
      discount: (item['discount'] as num).toDouble(),
      imageUrl: item['imageUrl'],
      available: item['available'],
      name: item['name'],
      description: item['description'],
      type: item['type'],
      category: item['category'],
      sizes: item['sizes'] != null
          ? (item['sizes'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                (value as num).toDouble(),
              ),
            )
          : null,
      extras: item['extras'] != null
          ? (item['extras'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                (value as num).toDouble(),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'price': price,
      'discount': discount,
      'imageUrl': imageUrl,
      'available': available,
      'name': name,
      'description': description,
      'type': type,
      'category': category,
      'sizes': sizes,
      'extras': extras,
    };
  }
}
