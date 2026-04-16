import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/fuel_provider.dart';
import '../../../shared/widgets/glass_pane.dart';
import '../../../shared/widgets/animated_input_field.dart';
import '../../../shared/widgets/dynamic_background.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../../shared/providers/history_provider.dart';
import '../../../shared/styles/app_styles.dart';

class FuelScreen extends ConsumerStatefulWidget {
  const FuelScreen({super.key});

  @override
  ConsumerState<FuelScreen> createState() => _FuelScreenState();
}

class _FuelScreenState extends ConsumerState<FuelScreen> {
  late TextEditingController _distanceController;
  late TextEditingController _fuelController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(fuelProvider);
    _distanceController = TextEditingController(text: state.distance.toStringAsFixed(1));
    _fuelController = TextEditingController(text: state.fuelVolume.toStringAsFixed(1));
    _priceController = TextEditingController(text: state.pricePerUnit.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _distanceController.dispose();
    _fuelController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fuelProvider);
    final notifier = ref.read(fuelProvider.notifier);

    final String distanceUnit = state.unitSystem == FuelUnitSystem.metric ? 'KM' : 'Miles';
    final String volumeUnit = state.unitSystem == FuelUnitSystem.metric ? 'Liters' : 'Gallons';
    final String efficiencyUnit = state.unitSystem == FuelUnitSystem.metric ? 'L/100km' : 'MPG';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(title: 'Fuel Calculator'),
      body: DynamicBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              children: [
                GlassPane(
                  child: Column(
                    children: [
                      _buildInputRow(
                        'Distance ($distanceUnit)',
                        _distanceController,
                        (val) {
                          final double? v = double.tryParse(val);
                          if (v != null) notifier.updateDistance(v);
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildInputRow(
                        'Fuel ($volumeUnit)',
                        _fuelController,
                        (val) {
                          final double? v = double.tryParse(val);
                          if (v != null) notifier.updateFuelVolume(v);
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildInputRow(
                        'Price per $volumeUnit',
                        _priceController,
                        (val) {
                          final double? v = double.tryParse(val);
                          if (v != null) notifier.updatePrice(v);
                        },
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            notifier.toggleUnitSystem();
                            final newState = ref.read(fuelProvider);
                            _distanceController.text = newState.distance.toStringAsFixed(1);
                            _fuelController.text = newState.fuelVolume.toStringAsFixed(1);
                          },
                          icon: const Icon(LucideIcons.refreshCw, size: 16),
                          label: Text('Switch to ${state.unitSystem == FuelUnitSystem.metric ? 'Imperial' : 'Metric'}'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(context).colorScheme.primary,
                            side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _ResultCard(
                        label: 'Efficiency',
                        value: state.efficiency.toStringAsFixed(1),
                        unit: efficiencyUnit,
                        icon: LucideIcons.gauge,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _ResultCard(
                        label: 'Total Cost',
                        value: state.totalCost.toStringAsFixed(2),
                        unit: 'USD',
                        icon: LucideIcons.banknote,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                GlassPane(
                  borderRadius: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.lightbulb, size: 16, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Eco Driving Tips',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Maintain steady speeds and avoid rapid acceleration to improve efficiency by up to 30%. Also, ensure your tires are properly inflated; low pressure increases fuel consumption!',
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

  Widget _buildInputRow(String label, TextEditingController controller, Function(String) onChanged) {
    return AnimatedInputField(
      controller: controller,
      label: label,
      onChanged: (val) {
        onChanged(val);
        _addHistory(ref);
      },
    );
  }

  void _addHistory(WidgetRef ref) {
    final state = ref.read(fuelProvider);
    final String efficiencyUnit = state.unitSystem == FuelUnitSystem.metric ? 'L/100km' : 'MPG';
    ref.read(historyProvider.notifier).addEntry(
          'Fuel Efficiency',
          '${state.efficiency.toStringAsFixed(1)} $efficiencyUnit',
        );
  }
}

class _ResultCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const _ResultCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPane(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ).animate().fadeIn().scale(),
          Text(
            unit,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
