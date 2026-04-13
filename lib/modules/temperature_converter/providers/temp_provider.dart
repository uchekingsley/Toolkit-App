import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/temp_unit.dart';

class TempState {
  final double inputValue;
  final TempUnit fromUnit;
  final TempUnit toUnit;
  final double result;

  TempState({
    this.inputValue = 0,
    this.fromUnit = TempUnit.celsius,
    this.toUnit = TempUnit.fahrenheit,
    this.result = 32,
  });

  TempState copyWith({
    double? inputValue,
    TempUnit? fromUnit,
    TempUnit? toUnit,
    double? result,
  }) {
    return TempState(
      inputValue: inputValue ?? this.inputValue,
      fromUnit: fromUnit ?? this.fromUnit,
      toUnit: toUnit ?? this.toUnit,
      result: result ?? this.result,
    );
  }
}

class TempNotifier extends Notifier<TempState> {
  @override
  TempState build() => TempState();

  void updateInput(double value) {
    state = state.copyWith(
      inputValue: value,
      result: TempUnit.convert(value, state.fromUnit, state.toUnit),
    );
  }

  void updateFromUnit(TempUnit unit) {
    state = state.copyWith(
      fromUnit: unit,
      result: TempUnit.convert(state.inputValue, unit, state.toUnit),
    );
  }

  void updateToUnit(TempUnit unit) {
    state = state.copyWith(
      toUnit: unit,
      result: TempUnit.convert(state.inputValue, state.fromUnit, unit),
    );
  }
}

final tempProvider = NotifierProvider<TempNotifier, TempState>(() {
  return TempNotifier();
});
