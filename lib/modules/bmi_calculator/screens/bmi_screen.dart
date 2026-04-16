import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/bmi_provider.dart';
import '../../../shared/widgets/glass_pane.dart';
import '../../../shared/widgets/animated_input_field.dart';
import '../../../shared/widgets/dynamic_background.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../../shared/providers/history_provider.dart';
import '../../../shared/services/haptic_service.dart';

class BMIScreen extends ConsumerStatefulWidget {
  const BMIScreen({super.key});

  @override
  ConsumerState<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends ConsumerState<BMIScreen> {
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(bmiProvider);
    _heightController = TextEditingController(text: state.height.toStringAsFixed(1));
    _weightController = TextEditingController(text: state.weight.toStringAsFixed(1));
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bmiProvider);
    final notifier = ref.read(bmiProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(title: 'BMI Calculator'),
      body: DynamicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                GlassPane(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AnimatedInputField(
                              controller: _heightController,
                              label: 'Height',
                              prefixText: '',
                              onChanged: (val) {
                                final double? value = double.tryParse(val);
                                if (value != null) {
                                  notifier.updateHeight(value);
                                  _addHistory(ref, state);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          _UnitToggle(
                            label: state.heightUnit.name.toUpperCase(),
                            onTap: () {
                              notifier.toggleHeightUnit();
                              _heightController.text = ref.read(bmiProvider).height.toStringAsFixed(1);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: AnimatedInputField(
                              controller: _weightController,
                              label: 'Weight',
                              prefixText: '',
                              onChanged: (val) {
                                final double? value = double.tryParse(val);
                                if (value != null) {
                                  notifier.updateWeight(value);
                                  _addHistory(ref, state);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          _UnitToggle(
                            label: state.weightUnit.name.toUpperCase(),
                            onTap: () {
                              notifier.toggleWeightUnit();
                              _weightController.text = ref.read(bmiProvider).weight.toStringAsFixed(1);
                            },
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
                        'Your BMI',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.bmi.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: _getCategoryColor(state.category),
                        ),
                      ).animate().fadeIn().scale(),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(state.category).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getCategoryColor(state.category).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          state.category.toUpperCase(),
                          style: TextStyle(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            color: _getCategoryColor(state.category),
                            fontSize: 14,
                          ),
                        ),
                      ).animate().fadeIn(delay: 200.ms),
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
                        Icon(LucideIcons.info, size: 16, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Health Insights',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Body Mass Index (BMI) is a person\'s weight in kilograms divided by the square of height in meters. A high BMI can indicate high body fatness. BMI screens for weight categories that may lead to health problems, but it does not diagnose the body fatness or health of an individual.',
                      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Underweight':
        return const Color(0xFF60A5FA); // Blue
      case 'Normal':
        return const Color(0xFF10B981); // Emerald
      case 'Overweight':
        return const Color(0xFFFBBF24); // Amber
      case 'Obese':
        return const Color(0xFFEF4444); // Red
      default:
        return Colors.grey;
    }
  }

  void _addHistory(WidgetRef ref, BMIState state) {
    ref.read(historyProvider.notifier).addEntry(
          'BMI Check',
          '${state.bmi.toStringAsFixed(1)} (${state.category})',
        );
  }
}

class _UnitToggle extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _UnitToggle({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
