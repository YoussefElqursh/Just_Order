import 'package:just_order/models/item_model.dart';

class Restaurant {
  String restaurantId;
  String name;
  String managerId;
  List<Item> items;

  Restaurant({
    required this.restaurantId,
    required this.name,
    required this.managerId,
    required this.items,
  });

  static fromMap(Map<String, dynamic> data) {
    return Restaurant(
      restaurantId: data['restaurantId'],
      name: data['name'],
      managerId: data['managerId'],
      items: data['items'].map<Item>((item) => Item.fromMap(item)).toList(),
    );
  }
}
