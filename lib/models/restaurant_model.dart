import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Restaurant {
  String restaurantId;
  String name;
  String managerId;
  String clubId;
  String? imageUrl;
  String? location;
  List<String> itemIds;
  double? deliveryFee;
  int orderTimeOut;

  Restaurant({
    required this.restaurantId,
    required this.name,
    required this.managerId,
    required this.clubId,
    this.imageUrl,
    this.location,
    required this.itemIds,
    this.deliveryFee,
    required this.orderTimeOut,
  });

  static Restaurant fromMap(Map<String, dynamic> data) {
    return Restaurant(
      restaurantId: data['restaurantId'],
      name: data['name'],
      managerId: data['managerId'],
      clubId: data['clubId'],
      imageUrl: data['imageUrl'],
      location: data['location'],
      itemIds: List<String>.from(data['itemIds']),
      deliveryFee: (data['deliveryFee'] as num?)?.toDouble(),
      orderTimeOut: (data['orderTimeOut'] as num).toInt(),
    );
  }

  static Future<void> saveRestaurantToPreferences(Restaurant restaurant) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('restaurant', jsonEncode(restaurant.toJson()));
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurantId': restaurantId,
      'name': name,
      'managerId': managerId,
      'clubId': clubId,
      'imageUrl': imageUrl,
      'location': location,
      'itemIds': itemIds,
      'deliveryFee': deliveryFee,
      'orderTimeOut': orderTimeOut,
    };
  }

  Future<Restaurant> getRestaurantFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final restaurantString = prefs.getString('restaurant');
    if (restaurantString != null) {
      return Restaurant.fromMap(jsonDecode(restaurantString));
    }
    return this;
  }

  static Restaurant? fromJson(String restaurantString) {
    return Restaurant.fromMap(jsonDecode(restaurantString));
  }
}
