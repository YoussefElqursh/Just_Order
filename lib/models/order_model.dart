import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_order/models/enums/status.dart';
import 'enums/payment_type.dart';

class Order {
  String orderId;
  String userId;
  String clubId;
  String restaurantId;
  String orderCode;
  String orderCodeForRestaurant;
  Status status;
  PaymentType paymentType;
  String invoiceId;
  int orderTimeOut;
  DateTime createdAt;
  double totalAmount;
  String? deliveryId;
  DateTime? updatedAt;
  DateTime? assignedDateTime;
  DateTime? deliveredDateTime;
  DateTime? finalisedDateTime;
  String? notes;

  Order({
    required this.orderId,
    required this.userId,
    required this.clubId,
    required this.restaurantId,
    required this.orderCode,
    required this.orderCodeForRestaurant,
    this.deliveryId,
    required this.status,
    required this.paymentType,
    required this.invoiceId,
    this.notes,
    required this.orderTimeOut,
    this.assignedDateTime,
    this.deliveredDateTime,
    this.finalisedDateTime,
    required this.createdAt,
    this.updatedAt,
    required this.totalAmount,
  });

  static Order fromMap(Map<String, dynamic> data) {
    return Order(
      orderId: data['orderId'],
      userId: data['userId'],
      clubId: data['clubId'],
      restaurantId: data['restaurantId'],
      orderCode: data['orderCode'],
      orderCodeForRestaurant: data['orderCodeForRestaurant']?? '',
      deliveryId: data['deliveryId'],
      status: Status.values
          // ignore: prefer_interpolation_to_compose_strings
          .firstWhere((e) => e.toString() == 'Status.' + data['status']),
      paymentType: PaymentType.values.firstWhere(
          // ignore: prefer_interpolation_to_compose_strings
          (e) => e.toString() == 'PaymentType.' + data['paymentType']),
      invoiceId: data['invoiceId'],
      notes: data['notes'],
      orderTimeOut: data['orderTimeOut'],
      assignedDateTime: data['assignedDateTime'] != null
          ? (data['assignedDateTime'] as Timestamp).toDate()
          : null,
      deliveredDateTime: data['deliveredDateTime'] != null
          ? (data['deliveredDateTime'] as Timestamp).toDate()
          : null,
      finalisedDateTime: data['finalisedDateTime'] != null
          ? (data['finalisedDateTime'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      totalAmount: data['totalAmount'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'clubId': clubId,
      'restaurantId': restaurantId,
      'orderCode': orderCode,
      'orderCodeForRestaurant': orderCodeForRestaurant,
      'deliveryId': deliveryId,
      'status': status.toString().split('.').last,
      'paymentType': paymentType.toString().split('.').last,
      'invoiceId': invoiceId,
      'notes': notes,
      'orderTimeOut': orderTimeOut,
      'assignedDateTime': assignedDateTime,
      'deliveredDateTime': deliveredDateTime,
      'finalisedDateTime': finalisedDateTime,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'totalAmount': totalAmount,
    };
  }

  String generateOrderCode() {
    Random random = Random();
    int randomNumber = 10000 + random.nextInt(90000);
    return randomNumber.toString();
  }
  String generateOrderCodeForRestaurant() {
    Random random = Random();
    int randomNumber = 10000 + random.nextInt(90000);
    return randomNumber.toString();
  }

  Future<String> generateUniqueOrderCode() async {
    String orderCode;
    bool isUnique = false;

    do {
      orderCode = generateOrderCode();

      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('orders')
          .where('status', isEqualTo: 'pending')
          .where('orderCode', isEqualTo: orderCode)
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        isUnique = true;
      }
    } while (!isUnique);

    return orderCode;
  }
  Future<String> generateUniqueOrderCodeForRestaurant() async {
    String orderCodeForRestaurant;
    bool isUnique = false;

    do {
      orderCodeForRestaurant = generateOrderCodeForRestaurant();

      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('orders')
          .where('status', isEqualTo: 'pending')
          .where('orderCodeForRestaurant', isEqualTo: orderCodeForRestaurant)
          .limit(1)
          .get();

      if (result.docs.isEmpty) {
        isUnique = true;
      }
    } while (!isUnique);

    return orderCodeForRestaurant;
  }
}
