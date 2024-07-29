import 'package:just_order/models/cart_item_model.dart';

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
}
