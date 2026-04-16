import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../routes/app_routes.dart';

class CommandResult {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onSelect;

  CommandResult({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onSelect,
  });
}

class CommandService {
  List<CommandResult> getSuggestions(String query, BuildContext context) {
    if (query.isEmpty) return [];

    final suggestions = <CommandResult>[];
    final q = query.toLowerCase();

    // 1. Currency Quick Jump
    if (q.contains('to') || _isCurrencyCode(q)) {
      suggestions.add(CommandResult(
        title: 'Currency Converter',
        subtitle: 'Convert values between currencies',
        icon: Icons.currency_exchange,
        onSelect: () => Navigator.pushNamed(context, AppRoutes.currency),
      ));
    }

    // 2. BMI Quick Jump
    if (q.contains('bmi') || q.contains('weight') || q.contains('health')) {
      suggestions.add(CommandResult(
        title: 'BMI Calculator',
        subtitle: 'Calculate Body Mass Index',
        icon: Icons.monitor_weight_outlined,
        onSelect: () => Navigator.pushNamed(context, AppRoutes.bmi),
      ));
    }

    // 3. Length/Weight/Temp
    if (q.contains('kg') || q.contains('lb') || q.contains('weight')) {
      suggestions.add(CommandResult(
        title: 'Weight Converter',
        subtitle: 'Convert kg, lb, oz, etc.',
        icon: Icons.scale,
        onSelect: () => Navigator.pushNamed(context, AppRoutes.weight),
      ));
    }

    if (q.contains('m') || q.contains('cm') || q.contains('inch') || q.contains('length')) {
      suggestions.add(CommandResult(
        title: 'Length Converter',
        subtitle: 'Convert meters, inches, feet, etc.',
        icon: Icons.straighten,
        onSelect: () => Navigator.pushNamed(context, AppRoutes.length),
      ));
    }

    if (q.contains('temp') || q.contains('celsius') || q.contains('f')) {
      suggestions.add(CommandResult(
        title: 'Temperature Converter',
        subtitle: 'Convert Celsius and Fahrenheit',
        icon: Icons.thermostat,
        onSelect: () => Navigator.pushNamed(context, AppRoutes.temperature),
      ));
    }

    // fuel
    if (q.contains('fuel') || q.contains('gas') || q.contains('trip')) {
      suggestions.add(CommandResult(
        title: 'Fuel Calculator',
        subtitle: 'Calculate trip costs and efficiency',
        icon: Icons.local_gas_station,
        onSelect: () => Navigator.pushNamed(context, AppRoutes.fuel),
      ));
    }

    // tasks
    if (q.contains('task') || q.contains('todo') || q.contains('list') || q.contains('check')) {
      suggestions.add(CommandResult(
        title: 'Task Manager',
        subtitle: 'View and manage your tasks',
        icon: Icons.check_box_outlined,
        onSelect: () => Navigator.pushNamed(context, AppRoutes.tasks),
      ));
    }

    if (q.contains('add') || q.contains('new')) {
       suggestions.add(CommandResult(
        title: 'Create New Task',
        subtitle: 'Quickly add a new item to your list',
        icon: Icons.add_task,
        onSelect: () => Navigator.pushNamed(context, AppRoutes.tasks), // In a real app we might trigger the sheet directly
      ));
    }

    return suggestions;
  }

  bool _isCurrencyCode(String q) {
    final codes = ['usd', 'eur', 'gbp', 'ngn', 'jpy', 'cad', 'aud'];
    return codes.any((code) => q.contains(code));
  }
}
