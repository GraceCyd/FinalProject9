class OrderListData {
  final int orderId;
  final int userId;
  final int productId;
  final int colorId;
  final int sizeId;
  final int receiptId;
  final int amount;
  final double total;
  final String productName;
  final int order_status;
  final  int transport_type;
  final String statusName;

  OrderListData ({
    required this.userId,
    required this.orderId,
    required this.productId,
    required this.colorId,
    required this.sizeId,
    required this.receiptId,
    required this.amount,
    required this.total,
    required this.productName,
    required this.order_status,
    required this.transport_type,
    required this.statusName
  });
  factory OrderListData.fromJSON(Map<String, dynamic> json) {
    return OrderListData (
      orderId: json["order_id"],
      userId: json["user_id"],
      productId: json["product_id"],
      colorId: json["color_id"],
      sizeId: json["size_id"],
      receiptId: json["receipt_id"],
      amount: json["amount"],
      total: double.parse(json["total"].toString()), 
      productName: json["product_name"],
      order_status: json["order_status"],
      transport_type: json["transport_type"],
      statusName: json["status_name"],
    );
  }
  
}