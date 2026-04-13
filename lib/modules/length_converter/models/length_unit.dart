enum LengthUnit {
  kilometers('km', 1000),
  meters('m', 1),
  centimeters('cm', 0.01),
  millimeters('mm', 0.001),
  miles('mi', 1609.34),
  yards('yd', 0.9144),
  feet('ft', 0.3048),
  inches('in', 0.0254);

  final String symbol;
  final double toMeters;

  const LengthUnit(this.symbol, this.toMeters);

  static double convert(double value, LengthUnit from, LengthUnit to) {
    double meters = value * from.toMeters;
    return meters / to.toMeters;
  }
}
