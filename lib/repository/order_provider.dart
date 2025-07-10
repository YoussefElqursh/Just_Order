import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_order/models/enums/status.dart';
import 'package:just_order/models/order_model.dart' as order_model;

import 'order_repository/order_repository.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository _orderSummaryRepository = OrderRepository();
  List<order_model.Order> _orders = [];

  List<order_model.Order> get orders => _orders;

  Future<void> updateOrderStatus(String orderId, Status newStatus) async {
    final order = _orders.firstWhere((order) => order.orderId == orderId);
    order.status = newStatus;
    _orderSummaryRepository.updateOrderStatus(
      orderId,
      newStatus.toString().split('.').last,
    );
    notifyListeners();
  }

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
