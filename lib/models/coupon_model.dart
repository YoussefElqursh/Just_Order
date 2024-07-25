class Coupon {
  String couponId;
  String code;
  double discountPercentage;
  DateTime createdAt;
  DateTime expiredAt;

  Coupon({
    required this.couponId,
    required this.code,
    required this.discountPercentage,
    required this.createdAt,
    required this.expiredAt,
  });
}