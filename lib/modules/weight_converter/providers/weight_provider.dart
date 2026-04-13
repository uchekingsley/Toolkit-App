import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weight_unit.dart';

class WeightState {
  final double inputValue;
  final WeightUnit fromUnit;
  final WeightUnit toUnit;
  final double result;

  WeightState({
    this.inputValue = 0,
    this.fromUnit = WeightUnit.kilograms,
    this.toUnit = WeightUnit.grams,
    this.result = 0,
  });

  WeightState copyWith({
    double? inputValue,
    WeightUnit? fromUnit,
    WeightUnit? toUnit,
    double? result,
  }) {
    return WeightState(
      inputValue: inputValue ?? this.inputValue,
      fromUnit: fromUnit ?? this.fromUnit,
      toUnit: toUnit ?? this.toUnit,
      result: result ?? this.result,
    );
  }
}

class WeightNotifier extends Notifier<WeightState> {
  @override
  WeightState build() => WeightState();

  void updateInput(double value) {
    state = state.copyWith(
      inputValue: value,
      result: WeightUnit.convert(value, state.fromUnit, state.toUnit),
    );
  }

  void updateFromUnit(WeightUnit unit) {
    state = state.copyWith(
      fromUnit: unit,
      result: WeightUnit.convert(state.inputValue, unit, state.toUnit),
    );
  }

  void updateToUnit(WeightUnit unit) {
    state = state.copyWith(
      toUnit: unit,
      result: WeightUnit.convert(state.inputValue, state.fromUnit, unit),
    );
  }
}

final weightProvider = NotifierProvider<WeightNotifier, WeightState>(() {
  return WeightNotifier();
});
