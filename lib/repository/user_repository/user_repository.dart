import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/models/restaurant_model.dart';

class UserRepository {

  final FirebaseFirestore _firestore;

  UserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

// home screen //
  Future<List<String>> getAllAdvertisements(String code) async {
    final snapshot = await _firestore.collection('advertisements').get();
    List<String> advertisements = [];
    for (var doc in snapshot.docs) {
      advertisements.add(doc.data()['imageURL']);
    }
    return advertisements;
  }

  Future<List<Item>> getPobularItems(String code) async {
    // logic to get popular items ****************
    List<Item> items = [];
    // for (var doc in snapshot.docs) {
    //   items.add(Item.fromMap(doc.data()));
    // }
    return items;
  }

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