enum TempUnit {
  celsius('°C'),
  fahrenheit('°F'),
  kelvin('K');

  final String symbol;
  const TempUnit(this.symbol);

  static double convert(double value, TempUnit from, TempUnit to) {
    if (from == to) return value;

    // Convert from 'from' to Celsius
    double celsius;
    switch (from) {
      case TempUnit.fahrenheit:
        celsius = (value - 32) * 5 / 9;
        break;
      case TempUnit.kelvin:
        celsius = value - 273.15;
        break;
      case TempUnit.celsius:
      default:
        celsius = value;
    }

    // Convert from Celsius to 'to'
    switch (to) {
      case TempUnit.fahrenheit:
        return (celsius * 9 / 5) + 32;
      case TempUnit.kelvin:
        return celsius + 273.15;
      case TempUnit.celsius:
      default:
        return celsius;
    }
  }
}
