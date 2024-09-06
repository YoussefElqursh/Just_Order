import 'package:just_order/models/enums/status.dart';

class DeliveryStatus {
  Status status;
  DateTime? updatedAt;

  DeliveryStatus({
    required this.status,
    this.updatedAt,
  });

  static fromMap(data) {
    return DeliveryStatus(
      status: Status.values
          .firstWhere((e) => e.toString() == 'Status.' + data['status']),
      updatedAt: data['updatedAt'],
    );
  }

  toMap() {
    return {
      'status': status.toString().split('.').last,
      'updatedAt': updatedAt,
    };
  }
}
