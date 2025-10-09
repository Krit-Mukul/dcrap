class ScrapItem {
  final String type;
  final double weightKg;
  final double? customRatePerKg;

  ScrapItem({required this.type, required this.weightKg, this.customRatePerKg});

  ScrapItem copyWith({
    String? type,
    double? weightKg,
    double? customRatePerKg,
  }) {
    return ScrapItem(
      type: type ?? this.type,
      weightKg: weightKg ?? this.weightKg,
      customRatePerKg: customRatePerKg ?? this.customRatePerKg,
    );
  }
}
