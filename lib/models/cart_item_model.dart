class CartItem {
  String cartItemId;
  String itemId;
  int quantity;
  double price;
  String description;

  CartItem({
    required this.cartItemId,
    required this.itemId,
    required this.quantity,
    required this.price,
    required this.description,
  });
}