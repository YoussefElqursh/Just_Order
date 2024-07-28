import 'package:just_order/models/meal_details_model.dart';

import 'enums/item_type.dart';

class Item {
  String itemId;
  String name;
  ItemType type;
  String description;
  double price;
  List<String> extras;
  bool available;
  MealDetails? mealDetails;

  Item({
    required this.itemId,
    required this.name,
    required this.type,
    required this.description,
    required this.price,
    required this.extras,
    required this.available,
    this.mealDetails,
  });
}
