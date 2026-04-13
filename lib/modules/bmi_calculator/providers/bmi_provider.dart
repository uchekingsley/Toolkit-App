import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HeightUnit { cm, ft }
enum WeightUnit { kg, lb }

class BMIState {
  final double height;
  final double weight;
  final HeightUnit heightUnit;
  final WeightUnit weightUnit;
  final double bmi;
  final String category;

  BMIState({
    this.height = 170.0,
    this.weight = 70.0,
    this.heightUnit = HeightUnit.cm,
    this.weightUnit = WeightUnit.kg,
    this.bmi = 24.22,
    this.category = 'Normal',
  });

  BMIState copyWith({
    double? height,
    double? weight,
    HeightUnit? heightUnit,
    WeightUnit? weightUnit,
    double? bmi,
    String? category,
  }) {
    return BMIState(
      height: height ?? this.height,
      weight: weight ?? this.weight,
      heightUnit: heightUnit ?? this.heightUnit,
      weightUnit: weightUnit ?? this.weightUnit,
      bmi: bmi ?? this.bmi,
      category: category ?? this.category,
    );
  }
}

class BMINotifier extends Notifier<BMIState> {
  @override
  BMIState build() => BMIState();

  void updateHeight(double h) {
    state = state.copyWith(height: h);
    _calculate();
  }

  void updateWeight(double w) {
    state = state.copyWith(weight: w);
    _calculate();
  }

  void toggleHeightUnit() {
    if (state.heightUnit == HeightUnit.cm) {
      state = state.copyWith(
        height: state.height / 30.48,
        heightUnit: HeightUnit.ft,
      );
    } else {
      state = state.copyWith(
        height: state.height * 30.48,
        heightUnit: HeightUnit.cm,
      );
    }
    _calculate();
  }

  void toggleWeightUnit() {
    if (state.weightUnit == WeightUnit.kg) {
      state = state.copyWith(
        weight: state.weight * 2.20462,
        weightUnit: WeightUnit.lb,
      );
    } else {
      state = state.copyWith(
        weight: state.weight / 2.20462,
        weightUnit: WeightUnit.kg,
      );
    }
    _calculate();
  }

  void _calculate() {
    double hInMeter = state.heightUnit == HeightUnit.cm 
        ? state.height / 100 
        : state.height * 0.3048;
    double wInKg = state.weightUnit == WeightUnit.kg 
        ? state.weight 
        : state.weight / 2.20462;

    if (hInMeter <= 0) return;

    double bmi = wInKg / (hInMeter * hInMeter);
    String category;

    if (bmi < 18.5) {
      category = 'Underweight';
    } else if (bmi < 25) {
      category = 'Normal';
    } else if (bmi < 30) {
      category = 'Overweight';
    } else {
      category = 'Obese';
    }

    state = state.copyWith(bmi: bmi, category: category);
  }
}

final bmiProvider = NotifierProvider<BMINotifier, BMIState>(() {
  return BMINotifier();
});
