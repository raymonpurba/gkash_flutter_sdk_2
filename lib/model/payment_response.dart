class PaymentResponse {
  final String? status;
  final String? description;
  final String? cid;
  final String? currency;
  final String? amount;
  final String? POID;
  final String? PaymentType;
  final String? cartid;

  PaymentResponse(this.status, this.description, this.cid, this.currency,
      this.amount, this.POID, this.PaymentType, this.cartid);

  factory PaymentResponse.fromJson(Map map) {
    return PaymentResponse(
        map["status"],
        map["description"],
        map["cid"],
        map["currency"],
        map["amount"],
        map["POID"],
        map["PaymentType"],
        map["cartid"]);
  }
}
