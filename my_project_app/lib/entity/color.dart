class ColorVariants {
  final int colorId;

  final String colorName;
  final String colorCode;

  const ColorVariants({
    required this.colorId,
    required this.colorName,
    required this.colorCode,
  });

  factory ColorVariants.fromJSON(Map<String, dynamic> json) {
    return ColorVariants(
        colorId: json["color_id"],
        colorName: json["color_name"],
        colorCode: json["color_code"]);
  }
}
