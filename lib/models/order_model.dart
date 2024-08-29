import 'package:just_order/models/cart_item_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'enums/order_status.dart';
import 'enums/payment_type.dart';

class Order {
  String orderId;
  String userId;
  String clubId;
  String restaurantId;
  List<CartItem> cartItems;
  String deliveryId;
  OrderStatus status;
  PaymentType paymentType;
  String invoiceId;
  String notes;
  DateTime orderDateTime;
  DateTime? assignedDateTime;
  DateTime? deliveredDateTime;
  DateTime? finalisedDateTime;
  String createdAt;
  String? updatedAt;

  Order({
    required this.orderId,
    required this.userId,
    required this.clubId,
    required this.restaurantId,
    required this.cartItems,
    required this.deliveryId,
    required this.status,
    required this.paymentType,
    required this.invoiceId,
    required this.notes,
    required this.orderDateTime,
    this.assignedDateTime,
    this.deliveredDateTime,
    this.finalisedDateTime,
    required this.createdAt,
    this.updatedAt,
  });

  static Order fromMap(Map<String, dynamic> data) {
    return Order(
      orderId: data['orderId'],
      userId: data['userId'],
      clubId: data['clubId'],
      restaurantId: data['restaurantId'],
      cartItems: data['cartItems'].map<CartItem>((item) => CartItem.fromMap(item)).toList(),
      deliveryId: data['deliveryId'],
      status: OrderStatus.values.firstWhere((e) => e.toString() == data['status']),
      paymentType: PaymentType.values.firstWhere((e) => e.toString() == data['paymentType']),
      invoiceId: data['invoiceId'],
      notes: data['notes'],
      orderDateTime: data['orderDateTime'].toDate(),
      assignedDateTime: data['assignedDateTime']?.toDate(),
      deliveredDateTime: data['deliveredDateTime']?.toDate(),
      finalisedDateTime: data['finalisedDateTime']?.toDate(),
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': generateOrderId(),
      'userId': getUserId(),
      'clubId': clubId,
      'restaurantId': restaurantId,
      'cartItems': cartItems.map((item) => item.toMap()).toList(),
      'deliveryId': deliveryId,
      'status': status.toString().split('.').last,
      'paymentType': paymentType.toString().split('.').last,
      'invoiceId': invoiceId,
      'notes': notes,
      'orderDateTime': orderDateTime,
      'assignedDateTime': assignedDateTime,
      'deliveredDateTime': deliveredDateTime,
      'finalisedDateTime': finalisedDateTime,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  String generateOrderId() {
    return FirebaseFirestore.instance.collection('orders').doc().id;
  }

  String getUserId() {
    // Get the current user ID
    return '1234567890';
  }
}
