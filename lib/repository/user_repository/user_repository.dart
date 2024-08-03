import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_order/models/restaurant_model.dart';

class UserRepository {

  final FirebaseFirestore _firestore;

  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Restaurant>> getAllAccessRestaurants(String code) async {
    final snapshot = await _firestore.collection('restaurants')
        .where('code', isEqualTo: code)
        .get();
    List<Restaurant> restaurants = [];
    for (var doc in snapshot.docs) {
      restaurants.add(Restaurant.fromMap(doc.data()));
    }
    return restaurants;
  }
}