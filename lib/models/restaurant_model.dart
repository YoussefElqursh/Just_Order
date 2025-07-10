import 'dart:convert';

class Restaurant {
  String restaurantId;
  String name;
  String managerId;
  String clubId;
  String? imageUrl;
  String? location;
  List<String> itemIds;
  List<String> categoriesId;
  double? deliveryFee;
  int orderTimeOut;
  bool hasOwnDelivery;

  Restaurant(
      {required this.restaurantId,
      required this.name,
      required this.managerId,
      required this.clubId,
      this.imageUrl,
      this.location,
      required this.itemIds,
      required this.categoriesId,
      this.deliveryFee,
      required this.orderTimeOut,
      required this.hasOwnDelivery});

  static Restaurant fromMap(Map<String, dynamic> data) {
    return Restaurant(
        restaurantId: data['restaurantId'],
        name: data['name'],
        managerId: data['managerId'],
        clubId: data['clubId'],
        imageUrl: data['imageUrl'],
        location: data['location'],
        itemIds: List<String>.from(data['itemIds']),
        categoriesId: List<String>.from(data['categoriesId']),
        deliveryFee: (data['deliveryFee'] as num?)?.toDouble(),
        orderTimeOut: (data['orderTimeOut'] as num).toInt(),
        hasOwnDelivery: (data['hasOwnDelivery']) as bool);
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
      'categoriesId': categoriesId,
      'deliveryFee': deliveryFee,
      'orderTimeOut': orderTimeOut,
      'hasOwnDelivery': hasOwnDelivery
    };
  }

  static Restaurant? fromJson(String restaurantString) {
    return Restaurant.fromMap(jsonDecode(restaurantString));
  }

  static empty() {
    return Restaurant(
        restaurantId: '',
        name: '',
        managerId: '',
        clubId: '',
        itemIds: [],
        categoriesId: [],
        orderTimeOut: 0,
        hasOwnDelivery: false);
  }
}
