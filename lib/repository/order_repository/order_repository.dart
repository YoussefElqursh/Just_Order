import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_order/models/cart_item_model.dart';
import 'package:just_order/models/order_model.dart' as order_model;
import 'package:just_order/models/restaurant_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<order_model.Order>> getOrders(String userId) async{
    return await _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get()
        .then((snapshot) {
      return snapshot.docs.map((doc) {
        return order_model.Order.fromMap(doc.data());
      }).toList();
    });
  }

  Future<List<Restaurant>> getRestaurants(List<String> restaurantIds) async {
    // Return an empty list if restaurantIds is empty
    if (restaurantIds.isEmpty) {
      return [];
    }

    // Proceed with Firestore query if restaurantIds is not empty
    final snapshot = await _firestore
        .collection('restaurants')
        .where(FieldPath.documentId, whereIn: restaurantIds)
        .get();

    return snapshot.docs.map((doc) {
      return Restaurant.fromMap(doc.data());
    }).toList();
  }

  Future<List<CartItem>> getCartItem(String orderId) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .doc(orderId)
          .collection('cartItems')
          .get();

      return snapshot.docs.map((doc) {
        return CartItem.fromMap(doc.data());
      }).toList();
    } catch (e) {
      debugPrint("Error fetching cart items: $e");
      return [];
    }
  }


  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore
        .collection('orders')
        .doc(orderId)
        .update({'status': status});
  }
}
