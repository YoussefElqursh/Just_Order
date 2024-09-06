import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_order/models/order_model.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/repository/order_repository/order_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider with ChangeNotifier {
  final OrderRepository orderRepository = OrderRepository();
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  OrderProvider() {
    _listenToOrderChanges();
  }

  Future<void> fetchOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString('user');
      if (userString != null) {
        final user = User.fromJson(jsonDecode(userString));
        final ordersSnapshot = await orderRepository.getOrdersByUserId(user?.userId);
        _orders = ordersSnapshot.docs.map((doc) => Order.fromMap(doc.data() as Map<String, dynamic>)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  void _listenToOrderChanges() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      final user = User.fromJson(jsonDecode(userString));
      orderRepository.getOrdersStreamByUserId(user?.userId).listen((snapshot) {
        _orders = snapshot.docs.map((doc) => Order.fromMap(doc.data() as Map<String, dynamic>)).toList();
        notifyListeners();
      });
    }
  }
}