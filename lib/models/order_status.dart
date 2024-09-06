import 'package:just_order/models/enums/status.dart';

class OrderStatus {
  Status status;
  String reason;
  DateTime? updatedAt;

  OrderStatus({
    required this.status,
    required this.reason,
    this.updatedAt,
  });

  static fromMap(data) {
    return OrderStatus(
      status: Status.values
          .firstWhere((e) => e.toString() == 'Status.' + data['status']),
      reason: data['reason'],
      updatedAt: data['updatedAt'],
    );
  }

  toMap() {
    return {
      'status': status.toString().split('.').last,
      'reason': reason,
      'updatedAt': updatedAt,
    };
  }
}
