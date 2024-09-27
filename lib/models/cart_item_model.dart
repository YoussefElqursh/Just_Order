import 'package:just_order/models/item_model.dart';

class CartItem {
  String cartItemId;
  Item item;
  int quantity;
  double price;
  Map<String, double>? size;
  Map<String, double>? extras;

  CartItem({
    required this.cartItemId,
    required this.item,
    required this.quantity,
    required this.price,
    this.extras,
    this.size,
  });

  num get totalPrice {
    double extrasTotal =
        extras?.values.fold(0.0, (sum, extra) => sum! + extra) ?? 0.0;
    return (price + extrasTotal) * quantity;
  }

  static CartItem fromMap(Map<String, dynamic> item) {
    return CartItem(
      cartItemId: item['cartItemId'],
      item: Item.fromMap(item['item']),
      quantity: item['quantity'],
      price: (item['price'] as num).toDouble(),
      size: item['size'] != null
          ? (item['size'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, (value as num).toDouble()))
          : null,
      extras: item['extras'] != null
          ? (item['extras'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, (value as num).toDouble()))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cartItemId': cartItemId,
      'item': item.toMap(),
      'quantity': quantity,
      'price': price,
      'extras': extras,
      'size': size,
    };
  }
}
