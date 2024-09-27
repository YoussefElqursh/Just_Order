import 'package:flutter/material.dart';
import 'package:just_order/models/cart_item_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(String cartItemId) {
    _items.removeWhere((item) => item.cartItemId == cartItemId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);
}
