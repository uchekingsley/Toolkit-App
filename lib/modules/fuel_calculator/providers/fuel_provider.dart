import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FuelUnitSystem { metric, imperial }

class FuelState {
  final double distance;
  final double fuelVolume;
  final double pricePerUnit;
  final FuelUnitSystem unitSystem;
  final double efficiency;
  final double totalCost;

  FuelState({
    this.distance = 100.0,
    this.fuelVolume = 8.0,
    this.pricePerUnit = 1.5,
    this.unitSystem = FuelUnitSystem.metric,
    this.efficiency = 8.0,
    this.totalCost = 12.0,
  });

  FuelState copyWith({
    double? distance,
    double? fuelVolume,
    double? pricePerUnit,
    FuelUnitSystem? unitSystem,
    double? efficiency,
    double? totalCost,
  }) {
    return FuelState(
      distance: distance ?? this.distance,
      fuelVolume: fuelVolume ?? this.fuelVolume,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      unitSystem: unitSystem ?? this.unitSystem,
      efficiency: efficiency ?? this.efficiency,
      totalCost: totalCost ?? this.totalCost,
    );
  }
}

class FuelNotifier extends Notifier<FuelState> {
  @override
  FuelState build() {
    return FuelState();
  }

  void updateDistance(double d) {
    state = state.copyWith(distance: d);
    _calculate();
  }

  void updateFuelVolume(double f) {
    state = state.copyWith(fuelVolume: f);
    _calculate();
  }

  void updatePrice(double p) {
    state = state.copyWith(pricePerUnit: p);
    _calculate();
  }

  void toggleUnitSystem() {
    if (state.unitSystem == FuelUnitSystem.metric) {
      // Metric -> Imperial
      state = state.copyWith(
        distance: state.distance * 0.621371, // km to miles
        fuelVolume: state.fuelVolume * 0.264172, // L to US gal
        unitSystem: FuelUnitSystem.imperial,
      );
    } else {
      // Imperial -> Metric
      state = state.copyWith(
        distance: state.distance / 0.621371,
        fuelVolume: state.fuelVolume / 0.264172,
        unitSystem: FuelUnitSystem.metric,
      );
    }
    _calculate();
  }

  void _calculate() {
    double efficiency;
    if (state.distance <= 0 || state.fuelVolume <= 0) {
      efficiency = 0;
    } else {
      if (state.unitSystem == FuelUnitSystem.metric) {
        // L/100km
        efficiency = (state.fuelVolume / state.distance) * 100;
      } else {
        // MPG
        efficiency = state.distance / state.fuelVolume;
      }
    }

    double totalCost = state.fuelVolume * state.pricePerUnit;

    state = state.copyWith(efficiency: efficiency, totalCost: totalCost);
  }
}

final fuelProvider = NotifierProvider<FuelNotifier, FuelState>(() {
  return FuelNotifier();
});
