import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/weight_provider.dart';
import '../models/weight_unit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../shared/widgets/glass_pane.dart';
import '../../../shared/widgets/animated_input_field.dart';
import '../../../shared/widgets/dynamic_background.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../../shared/providers/history_provider.dart';
import '../../../shared/styles/app_styles.dart';

class WeightScreen extends ConsumerStatefulWidget {
  const WeightScreen({super.key});

  @override
  ConsumerState<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends ConsumerState<WeightScreen> {
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
    final state = ref.watch(weightProvider);
    final notifier = ref.read(weightProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(title: 'Mass Converter'),
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
                              'Weight: ${state.fromUnit.symbol} to ${state.toUnit.symbol}',
                              '${state.result.toStringAsFixed(2)} ${state.toUnit.symbol}',
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
                        child: Icon(LucideIcons.scale, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.12)),
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
                    state.result.toStringAsFixed(4),
                    style: AppTextStyles.displayMedium.copyWith(
                      color: AppColors.secondary,
                      fontSize: 48,
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
                      const Icon(LucideIcons.info, size: 16, color: AppColors.secondary),
                      const SizedBox(width: 8),
                      Text(
                        'Mass Insights',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Weight is actually the force exerted by gravity. In common usage, we mean mass. The Kilogram is the SI base unit of mass. Until recently, it was defined by a physical platinum-iridium cylinder kept in France!',
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
  final WeightUnit value;
  final ValueChanged<WeightUnit?> onChanged;

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
        DropdownButton<WeightUnit>(
          value: value,
          isExpanded: true,
          underline: const SizedBox(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
          dropdownColor: Theme.of(context).colorScheme.surface,
          items: WeightUnit.values.map((unit) {
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
