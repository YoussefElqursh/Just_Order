import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_order/models/delivery_status.dart';
import 'package:just_order/models/enums/status.dart';
import 'package:just_order/models/order_status.dart';
import 'enums/payment_type.dart';

class Order {
  String orderId;
  String userId;
  String clubId;
  String restaurantId;
  Status status;
  PaymentType paymentType;
  String invoiceId;
  int orderTimeOut;
  DateTime createdAt;
  OrderStatus orderStatus;
  double totalAmount;
  String? deliveryId;
  DeliveryStatus? deliveryStatus;
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
    required this.orderStatus,
    this.deliveryStatus,
    required this.totalAmount,
  });

  static Order fromMap(Map<String, dynamic> data) {
    return Order(
      orderId: data['orderId'],
      userId: data['userId'],
      clubId: data['clubId'],
      restaurantId: data['restaurantId'],
      deliveryId: data['deliveryId'],
      status: Status.values
          .firstWhere((e) => e.toString() == 'Status.' + data['status']),
      paymentType: PaymentType.values.firstWhere(
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
      orderStatus: OrderStatus.fromMap(data['orderStatus']),
      deliveryStatus: data['deliveryStatus'] != null
          ? DeliveryStatus.fromMap(data['deliveryStatus'])
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
      'orderStatus': orderStatus.toMap(),
      'deliveryStatus': deliveryStatus?.toMap(),
      'totalAmount': totalAmount,
    };
  }
}