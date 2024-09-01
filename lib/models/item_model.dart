class Item {
  String itemId;
  double price;
  String imageUrl;
  bool available;
  String name;
  String description;
  String type;
  String category;

  Item({
    required this.itemId,
    required this.price,
    required this.imageUrl,
    required this.available,
    required this.name,
    required this.description,
    required this.type,
    required this.category,
  });

  static Item fromMap(Map<String, dynamic> item) {
    return Item(
      itemId: item['itemId'],
      price: (item['price'] as num).toDouble(),
      imageUrl: item['imageUrl'],
      available: item['available'],
      name: item['name'],
      description: item['description'],
      type: item['type'],
      category: item['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'price': price,
      'imageUrl': imageUrl,
      'available': available,
      'name': name,
      'description': description,
      'type': type,
      'category': category,
    };
  }

  toJson() {
    return {
      'itemId': itemId,
      'price': price,
      'imageUrl': imageUrl,
      'available': available,
      'name': name,
      'description': description,
      'type': type,
      'category': category,
    };
  }
}