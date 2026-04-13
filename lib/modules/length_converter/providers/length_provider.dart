import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/length_unit.dart';

class LengthState {
  final double inputValue;
  final LengthUnit fromUnit;
  final LengthUnit toUnit;
  final double result;

  LengthState({
    this.inputValue = 0,
    this.fromUnit = LengthUnit.meters,
    this.toUnit = LengthUnit.kilometers,
    this.result = 0,
  });

  LengthState copyWith({
    double? inputValue,
    LengthUnit? fromUnit,
    LengthUnit? toUnit,
    double? result,
  }) {
    return LengthState(
      inputValue: inputValue ?? this.inputValue,
      fromUnit: fromUnit ?? this.fromUnit,
      toUnit: toUnit ?? this.toUnit,
      result: result ?? this.result,
    );
  }
}

class LengthNotifier extends Notifier<LengthState> {
  @override
  LengthState build() => LengthState();

  void updateInput(double value) {
    state = state.copyWith(
      inputValue: value,
      result: LengthUnit.convert(value, state.fromUnit, state.toUnit),
    );
  }

  void updateFromUnit(LengthUnit unit) {
    state = state.copyWith(
      fromUnit: unit,
      result: LengthUnit.convert(state.inputValue, unit, state.toUnit),
    );
  }

  void updateToUnit(LengthUnit unit) {
    state = state.copyWith(
      toUnit: unit,
      result: LengthUnit.convert(state.inputValue, state.fromUnit, unit),
    );
  }
}

final lengthProvider = NotifierProvider<LengthNotifier, LengthState>(() {
  return LengthNotifier();
});
