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
  String orderTable;
  Status status;
  PaymentType paymentType;
  int orderTimeOut;
  DateTime createdAt;
  double totalAmount;
  double subTotal;
  double serviceFee;
  double deliveryFee;
  String? deliveryId;
  DateTime? updatedAt;
  DateTime? assignedDateTime;
  DateTime? deliveredDateTime;
  DateTime? finalisedDateTime;
  bool processed;
  bool addedToInvoice;
  String? notes;
  bool deliveredByRestaurant;

  Order(
      {required this.orderId,
      required this.userId,
      required this.clubId,
      required this.restaurantId,
      required this.orderCode,
      required this.orderCodeForRestaurant,
      required this.orderTable,
      this.deliveryId,
      required this.status,
      required this.paymentType,
      this.notes,
      required this.orderTimeOut,
      this.assignedDateTime,
      this.deliveredDateTime,
      this.finalisedDateTime,
      required this.createdAt,
      this.updatedAt,
      required this.totalAmount,
      required this.subTotal,
      required this.serviceFee,
      required this.deliveryFee,
      required this.processed,
      required this.addedToInvoice,
      required this.deliveredByRestaurant});

  static Order fromMap(Map<String, dynamic> data) {
    return Order(
      orderId: data['orderId'] ?? 'noOrderId',
      userId: data['userId'] ?? 'noUserId',
      clubId: data['clubId'] ?? 'noClubId',
      restaurantId: data['restaurantId'] ?? 'noRestaurantId',
      orderCode: data['orderCode'] ?? 'noOrderCode',
      orderCodeForRestaurant:
          data['orderCodeForRestaurant'] ?? 'noOrderCodeForRestaurant',
      orderTable: data['orderTable'] ?? 'noOrderTable',
      deliveryId: data['deliveryId'] ?? 'noDeliveryId',
      status: Status.values
          // ignore: prefer_interpolation_to_compose_strings
          .firstWhere((e) => e.toString() == 'Status.' + data['status']),
      paymentType: PaymentType.values.firstWhere(
          // ignore: prefer_interpolation_to_compose_strings
          (e) => e.toString() == 'PaymentType.' + data['paymentType']),
      notes: data['notes'] ?? 'noNotes',
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
      totalAmount: data['totalAmount'] ?? 0,
      subTotal: data['subTotal'] ?? 0,
      serviceFee: data['serviceFee'] ?? 0,
      deliveryFee: data['deliveryFee'] ?? 0,
      processed: false,
      addedToInvoice: false,
      deliveredByRestaurant: data['deliveredByRestaurant'] ?? false,
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
      'orderTable': orderTable,
      'deliveryId': deliveryId,
      'status': status.toString().split('.').last,
      'paymentType': paymentType.toString().split('.').last,
      'notes': notes,
      'orderTimeOut': orderTimeOut,
      'assignedDateTime': assignedDateTime,
      'deliveredDateTime': deliveredDateTime,
      'finalisedDateTime': finalisedDateTime,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'totalAmount': totalAmount,
      'serviceFee': serviceFee,
      'deliveryFee': deliveryFee,
      'subTotal': subTotal,
      'processed': processed,
      'deliveredByRestaurant': deliveredByRestaurant
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
