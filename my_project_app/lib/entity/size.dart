class SizeVariants {
  final int sizeId;

  final String sizeName;

  const SizeVariants({
    required this.sizeId,
    required this.sizeName,
  });

  factory SizeVariants.fromJSON(Map<String, dynamic> json) {
    return SizeVariants(sizeId: json["size_id"], sizeName: json["size_name"]);
  }
}
