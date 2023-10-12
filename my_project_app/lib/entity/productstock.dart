class ProductName {
  final int productId;
  final String productName;

  ProductName({required this.productId, required this.productName});

  factory ProductName.fromJSON(Map<String, dynamic> json) {
    return ProductName(
      productId: json["product_id"] ?? 0,
      productName: json["product_name"] ?? "",
    );
  }
}
