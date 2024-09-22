import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_order/models/cart_item_model.dart';
import 'package:just_order/models/invoice_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/models/order_model.dart' as order_model;

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<order_model.Order>> getOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get()
        .then((snapshot) {
      return snapshot.docs.map((doc) {
        return order_model.Order.fromMap(doc.data());
      }).toList();
    });
  }

  Future<List<Restaurant>> getRestaurants(List<String> restaurantIds) {
    return _firestore
        .collection('restaurants')
        .where(FieldPath.documentId, whereIn: restaurantIds)
        .get()
        .then((snapshot) {
      return snapshot.docs.map((doc) {
        return Restaurant.fromMap(doc.data());
      }).toList();
    });
  }

  Future<List<CartItem>> getCartItem(String orderId) {
    return _firestore
        .collection('orders')
        .doc(orderId)
        .collection('cartItems')
        .get()
        .then((snapshot) {
      return snapshot.docs.map((doc) {
        return CartItem.fromMap(doc.data());
      }).toList();
    });
  }

  Future<Invoice> getInvoice(String orderId) async {
    final snapshot = await _firestore
        .collection('invoices')
        .where('orderId', isEqualTo: orderId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return Invoice.fromMap(snapshot.docs.first.data());
    } else {
      throw Exception('Invoice not found');
    }
  }
}
