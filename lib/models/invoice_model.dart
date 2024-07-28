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
}
