import 'package:just_order/models/restaurant_model.dart';

class Club {
  String clubId;
  String name;
  String location;
  List<Restaurant> restaurants;

  Club({
    required this.clubId,
    required this.name,
    required this.location,
    required this.restaurants,
  });
}
