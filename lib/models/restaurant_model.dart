import 'dart:convert';

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
      orderTimeOut: 0,
    );
  }
}
