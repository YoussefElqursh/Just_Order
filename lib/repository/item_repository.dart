import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_order/models/item_model.dart';

class ItemRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Item>> getItemsByCategory(String categoryName) async {
    final snapshot = await _firestore
        .collection('items')
        .where('category', isEqualTo: categoryName)
        .get();

    return snapshot.docs.map((doc) => Item.fromMap(doc.data())).toList();
  }
}
