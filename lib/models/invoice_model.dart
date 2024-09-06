import 'package:cloud_firestore/cloud_firestore.dart';

class Invoice {
  String invoiceId;
  String orderId;
  String clubId;
  String restaurantId;
  double serviceFees;
  double totalFees;
  DateTime createdAt;
  DateTime? updatedAt;

  Invoice({
    required this.invoiceId,
    required this.orderId,
    required this.clubId,
    required this.restaurantId,
    required this.serviceFees,
    required this.totalFees,
    required this.createdAt,
    this.updatedAt,
  });

  static fromMap(data) {
    return Invoice(
      invoiceId: data['invoiceId'],
      orderId: data['orderId'],
      clubId: data['clubId'],
      restaurantId: data['restaurantId'],
      serviceFees: (data['serviceFees'] as num).toDouble(),
      totalFees: (data['totalFees'] as num).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoiceId': invoiceId,
      'orderId': orderId,
      'clubId': clubId,
      'restaurantId': restaurantId,
      'serviceFees': serviceFees,
      'totalFees': totalFees,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
