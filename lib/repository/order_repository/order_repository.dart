import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_order/models/cart_item_model.dart';
import 'package:just_order/models/invoice_model.dart';
import 'package:just_order/models/restaurant_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Restaurant> getRestaurant(String restaurantId) {
    return _firestore
        .collection('restaurants')
        .doc(restaurantId)
        .get()
        .then((doc) {
      return Restaurant.fromMap(doc.data() ?? {});
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

  Future<QuerySnapshot> getOrdersByUserId(String? userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get();
  }

  Stream<QuerySnapshot> getOrdersStreamByUserId(String? userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots();
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