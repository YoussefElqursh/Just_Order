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
}
