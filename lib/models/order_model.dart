import 'package:just_order/models/item_model.dart';

import 'enums/order_status.dart';
import 'enums/payment_type.dart';

class Order {
  String orderId;
  String userId;
  String branchId;
  List<Item> items;
  String deliveryId;
  OrederStatus status;
  PaymentType paymentType;
  String invoiceId;
  String notes;
  DateTime orderDateTime;
  DateTime assignedDateTime;
  DateTime deliveredDateTime;
  DateTime finalisedDateTime;
  String createdAt;
  String updatedAt;

  Order({
    required this.orderId,
    required this.userId,
    required this.branchId,
    required this.items,
    required this.deliveryId,
    required this.status,
    required this.paymentType,
    required this.invoiceId,
    required this.notes,
    required this.orderDateTime,
    required this.assignedDateTime,
    required this.deliveredDateTime,
    required this.finalisedDateTime,
    required this.createdAt,
    required this.updatedAt,
  });
}
