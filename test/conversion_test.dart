import 'package:flutter_test/flutter_test.dart';
import 'package:smart_utility_toolkit/modules/length_converter/models/length_unit.dart';
import 'package:smart_utility_toolkit/modules/temperature_converter/models/temp_unit.dart';
import 'package:smart_utility_toolkit/modules/weight_converter/models/weight_unit.dart';

void main() {
  group('Length Conversion Tests', () {
    test('Meters to Kilometers', () {
      expect(LengthUnit.convert(1000, LengthUnit.meters, LengthUnit.kilometers), 1.0);
    });
    test('Miles to Meters', () {
      expect(LengthUnit.convert(1, LengthUnit.miles, LengthUnit.meters), 1609.34);
    });
  });

  group('Temperature Conversion Tests', () {
    test('Celsius to Fahrenheit', () {
      expect(TempUnit.convert(0, TempUnit.celsius, TempUnit.fahrenheit), 32.0);
    });
    test('Fahrenheit to Celsius', () {
      expect(TempUnit.convert(32, TempUnit.fahrenheit, TempUnit.celsius), 0.0);
    });
    test('Celsius to Kelvin', () {
      expect(TempUnit.convert(0, TempUnit.celsius, TempUnit.kelvin), 273.15);
    });
  });

  group('Weight Conversion Tests', () {
    test('Kilograms to Grams', () {
      expect(WeightUnit.convert(1, WeightUnit.kilograms, WeightUnit.grams), 1000.0);
    });
    test('Pounds to Grams', () {
      expect(WeightUnit.convert(1, WeightUnit.pounds, WeightUnit.grams), 453.592);
    });
  });
}
