double calculateStampDuty(double propertyPrice, Map<int, double> bands) {
  if (bands.isEmpty) return 0.0;

  // Sort thresholds ascending
  final thresholds = bands.keys.toList()..sort();
  double totalTax = 0.0;

  for (int i = 0; i < thresholds.length; i++) {
    final lower = thresholds[i];
    final rate = bands[lower]!;
    final upper = (i + 1 < thresholds.length)
        ? thresholds[i + 1]
        : double.infinity;

    if (propertyPrice > lower) {
      final taxableAmountInBand =
          (propertyPrice > upper ? upper : propertyPrice) - lower;
      totalTax += taxableAmountInBand * rate;
    }
  }
  return totalTax;
}
