enum WeightUnit {
  kilograms('kg', 1000),
  grams('g', 1),
  milligrams('mg', 0.001),
  pounds('lb', 453.592),
  ounces('oz', 28.3495);

  final String symbol;
  final double toGrams;

  const WeightUnit(this.symbol, this.toGrams);

  static double convert(double value, WeightUnit from, WeightUnit to) {
    double grams = value * from.toGrams;
    return grams / to.toGrams;
  }
}
