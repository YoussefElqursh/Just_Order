import 'package:flutter/material.dart';
import 'package:just_order/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void addOrders(List<Order> fetchedOrders) {
    _orders = fetchedOrders;
    notifyListeners();
  }
}