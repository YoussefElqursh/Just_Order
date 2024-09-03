import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/models/restaurant_model.dart';

class UserRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Restaurant>> getRestaurants(String code) async {

    String clubId = int.parse(code.substring(0, 2)).toString();

    QuerySnapshot snapshot = await firestore
        .collection('restaurants')
        .where('clubId', isEqualTo: clubId)
        .get();

    List<Restaurant> restaurants = [];

    snapshot.docs.forEach((doc) {
      restaurants.add(Restaurant.fromMap(doc.data() as Map<String, dynamic>));
    });

    return restaurants;
  }

  Future<List<Item>> getItems(List<String> itemIds) async {
    List<Item> items = [];

    for (String itemId in itemIds) {
      DocumentSnapshot snapshot = await firestore.collection('items').doc(itemId).get();
      items.add(Item.fromMap(snapshot.data() as Map<String, dynamic>));
    }

    return items;
  }
}
