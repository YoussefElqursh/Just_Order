class CartItem {
  String cartItemId;
  String itemId;
  int quantity;
  double price;
  String description;
  List<String>? extras;

  CartItem({
    required this.cartItemId,
    required this.itemId,
    required this.quantity,
    required this.price,
    required this.description,
    this.extras,
  });

  static fromMap(item) {
    return CartItem(
      cartItemId: item['cartItemId'],
      itemId: item['itemId'],
      quantity: item['quantity'],
      price: item['price'],
      description: item['description'],
      extras: item['extras']?.cast<String>(),
    );
  }

  toMap() {
    return {
      'cartItemId': cartItemId,
      'itemId': itemId,
      'quantity': quantity,
      'price': price,
      'description': description,
      'extras': extras,
    };
  }
}
