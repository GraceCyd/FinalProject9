class Receipt{
  final int receiptId;
  final String receipt_image;
  final String data_add;

  const Receipt({
    required this.receiptId,
    required this.receipt_image,
    required this.data_add,
  });

  factory Receipt.fromJSON(Map<String, dynamic> json) {
    return Receipt(
      receiptId: json["receipt_id"],
      receipt_image: json["receipt_image"],
      data_add: json["data_add"],
    );
  }
}