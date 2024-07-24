class Invoice {
  String invoiceId;
  String orderId;
  String branchId;
  double serviceFees;
  double totalFees;
  DateTime createdAt;
  DateTime updatedAt;

  Invoice({
    required this.invoiceId,
    required this.orderId,
    required this.branchId,
    required this.serviceFees,
    required this.totalFees,
    required this.createdAt,
    required this.updatedAt,
  });
}
