import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_order/models/order_model.dart' as order_model;

class OrderProvider with ChangeNotifier {
  List<order_model.Order> _orders = [];

  List<order_model.Order> get orders => _orders;

  void listenToOrders(String userId) {
    FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      _orders = snapshot.docs
          .map((doc) => order_model.Order.fromMap(doc.data()))
          .toList();
      notifyListeners();
    });
  }
}
