class PaymentRequestModel {
  Map paymentKeys, intentionDetails, paymentMethod;
  List<dynamic> cardTokens;
  String id, clientSecret, specialReference;

  PaymentRequestModel.name(
      this.paymentKeys,
      this.intentionDetails,
      this.paymentMethod,
      this.cardTokens,
      this.id,
      this.clientSecret,
      this.specialReference);

  factory PaymentRequestModel.fromJson(Map<String, dynamic> json) {
    return PaymentRequestModel.name(
        (json["payment_keys"] as List)[0],
        json["intention_detail"] as Map,
        (json["payment_methods"] as List)[0],
        (json["card_tokens"] as List) ?? [],
        json["id"] as String,
        json["client_secret"] as String,
        json["special_reference"] as String);
  }
}
