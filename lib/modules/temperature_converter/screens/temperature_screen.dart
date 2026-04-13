import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/temp_provider.dart';
import '../models/temp_unit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/widgets/glass_pane.dart';
import '../../../shared/widgets/animated_input_field.dart';
import '../../../shared/widgets/dynamic_background.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../../shared/providers/history_provider.dart';

class TemperatureScreen extends ConsumerStatefulWidget {
  const TemperatureScreen({super.key});

  @override
  ConsumerState<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends ConsumerState<TemperatureScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tempProvider);
    final notifier = ref.read(tempProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(title: 'Temperature Scale'),
      body: DynamicBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 120, left: 24, right: 24, bottom: 24),
          child: Column(
            children: [
              GlassPane(
                child: Column(
                  children: [
                    AnimatedInputField(
                      controller: _controller,
                      label: 'From',
                      prefixText: state.fromUnit.symbol,
                      onChanged: (val) {
                        final double? value = double.tryParse(val);
                        if (value != null) {
                          notifier.updateInput(value);
                          ref.read(historyProvider.notifier).addEntry(
                                'Temp: ${state.fromUnit.symbol} to ${state.toUnit.symbol}',
                                '${state.result.toStringAsFixed(1)} ${state.toUnit.symbol}',
                              );
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _UnitDropdown(
                            label: 'From Unit',
                            value: state.fromUnit,
                            onChanged: (unit) {
                              if (unit != null) notifier.updateFromUnit(unit);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(LucideIcons.thermometer, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
                        ),
                        Expanded(
                          child: _UnitDropdown(
                            label: 'To Unit',
                            value: state.toUnit,
                            onChanged: (unit) {
                              if (unit != null) notifier.updateToUnit(unit);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              GlassPane(
                borderRadius: 32,
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Text(
                      'Result',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.result.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF472B6),
                      ),
                    ).animate().fadeIn().scale(),
                    Text(
                      state.toUnit.name.toUpperCase(),
                      style: TextStyle(
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              GlassPane(
                borderRadius: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(LucideIcons.info, size: 16, color: Color(0xFFF472B6)),
                        const SizedBox(width: 8),
                        Text(
                          'Thermal Insights',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Temperature is a physical quantity that expresses hot and cold. While Celsius is common for daily use, Kelvin is the SI base unit used in scientific applications. Absolute zero is 0K or -273.15°C.',
                      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnitDropdown extends StatelessWidget {
  final String label;
  final TempUnit value;
  final ValueChanged<TempUnit?> onChanged;

  const _UnitDropdown({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38)),
        ),
        DropdownButton<TempUnit>(
          value: value,
          isExpanded: true,
          underline: const SizedBox(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
          dropdownColor: Theme.of(context).colorScheme.surface,
          items: TempUnit.values.map((unit) {
            return DropdownMenuItem(
              value: unit,
              child: Text(unit.name[0].toUpperCase() + unit.name.substring(1)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
