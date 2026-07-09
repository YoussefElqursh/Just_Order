import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/models/restaurant_model.dart';

class ItemRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Item>> getItemsByCategory(String categoryName) async {
    final snapshot = await _firestore
        .collection('items')
        .where('category', isEqualTo: categoryName)
        .get();

    return snapshot.docs.map((doc) => Item.fromMap(doc.data())).toList();
  }

  Future<Restaurant?> getRestaurantForItem(Item item) async {
    if (item.restaurantId != null && item.restaurantId!.isNotEmpty) {
      final doc = await _firestore
          .collection('restaurants')
          .doc(item.restaurantId)
          .get();
      if (doc.exists && doc.data() != null) {
        return Restaurant.fromMap(doc.data()!);
      }
    }

    final snapshot = await _firestore
        .collection('restaurants')
        .where('itemIds', arrayContains: item.itemId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return Restaurant.fromMap(snapshot.docs.first.data());
  }
}
