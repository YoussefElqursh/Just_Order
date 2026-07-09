import 'package:flutter/material.dart';
import 'package:just_order/models/order_model.dart';

/// Returns a color representing how close an order is to timing out,
/// based on the elapsed time since [Order.createdAt] relative to
/// [Order.orderTimeOut].
///
/// - 0-25% elapsed  -> green
/// - 25-50% elapsed -> yellow
/// - 50-75% elapsed -> orange
/// - 75-100% elapsed (or more) -> red
Color getOrderProgressColor(Order order) {
  final timeDifference = DateTime.now().difference(order.createdAt).inMinutes;

  if (timeDifference <= order.orderTimeOut * 0.25) {
    return Colors.green;
  } else if (timeDifference <= order.orderTimeOut * 0.5) {
    return Colors.yellow;
  } else if (timeDifference <= order.orderTimeOut * 0.75) {
    return Colors.orange;
  } else {
    return Colors.red;
  }
}
