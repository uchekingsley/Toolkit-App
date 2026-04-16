import 'package:flutter/material.dart';
import '../modules/home/screens/home_screen.dart';
import '../modules/length_converter/screens/length_screen.dart';
import '../modules/temperature_converter/screens/temperature_screen.dart';
import '../modules/weight_converter/screens/weight_screen.dart';

import '../modules/more/screens/more_screen.dart';
import '../modules/currency_converter/screens/currency_screen.dart';
import '../modules/bmi_calculator/screens/bmi_screen.dart';
import '../modules/fuel_calculator/screens/fuel_screen.dart';
import '../modules/task_manager/screens/task_manager_screen.dart';

// app routes
class AppRoutes {
  static const String home = '/';
  static const String length = '/length';
  static const String temperature = '/temperature';
  static const String weight = '/weight';
  static const String more = '/more';
  static const String currency = '/currency';
  static const String bmi = '/bmi';
  static const String fuel = '/fuel';
  static const String tasks = '/tasks';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomeScreen(),
        length: (context) => const LengthScreen(),
        temperature: (context) => const TemperatureScreen(),
        weight: (context) => const WeightScreen(),
        more: (context) => const MoreScreen(),
        currency: (context) => const CurrencyScreen(),
        bmi: (context) => const BMIScreen(),
        fuel: (context) => const FuelScreen(),
        tasks: (context) => const TaskManagerScreen(),
      };
}
