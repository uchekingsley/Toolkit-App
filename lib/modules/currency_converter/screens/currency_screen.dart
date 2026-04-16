import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/currency_provider.dart';
import '../../../shared/widgets/glass_pane.dart';
import '../../../shared/widgets/animated_input_field.dart';
import '../../../shared/widgets/dynamic_background.dart';
import '../../../shared/widgets/glass_app_bar.dart';
import '../../../shared/providers/history_provider.dart';
import '../../../shared/services/haptic_service.dart';

class CurrencyScreen extends ConsumerStatefulWidget {
  const CurrencyScreen({super.key});

  @override
  ConsumerState<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends ConsumerState<CurrencyScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '1.0');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(currencyProvider);
    final notifier = ref.read(currencyProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(title: 'Currency Exchange'),
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
                      label: 'Amount',
                      prefixText: state.fromCurrency == 'USD' ? '\$ ' : '',
                      onChanged: (val) {
                        final double? value = double.tryParse(val);
                        if (value != null) {
                          notifier.updateAmount(value);
                          ref.read(historyProvider.notifier).addEntry(
                                'Currency: ${state.fromCurrency} to ${state.toCurrency}',
                                '${state.result.toStringAsFixed(2)} ${state.toCurrency}',
                              );
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _CurrencyDropdown(
                            label: 'From',
                            value: state.fromCurrency,
                            items: state.rates.keys.toList(),
                            onChanged: (val) {
                              if (val != null) {
                                HapticService.selection();
                                notifier.updateFromCurrency(val);
                               }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: IconButton(
                            onPressed: () {
                              HapticService.medium();
                              notifier.swapCurrencies();
                            },
                            icon: Icon(
                              LucideIcons.arrowRightLeft,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _CurrencyDropdown(
                            label: 'To',
                            value: state.toCurrency,
                            items: state.rates.keys.toList(),
                            onChanged: (val) {
                              if (val != null) {
                                HapticService.selection();
                                notifier.updateToCurrency(val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (state.history.isNotEmpty)
                GlassPane(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '7D Trend',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            state.fromCurrency == 'USD' && state.toCurrency == 'EUR' ? 'Direct Rate' : 'Estimated',
                            style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 60,
                        child: LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: const FlTitlesData(show: false),
                            borderData: FlBorderData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: state.history.asMap().entries.map((e) {
                                  return FlSpot(e.key.toDouble(), e.value);
                                }).toList(),
                                isCurved: true,
                                color: Theme.of(context).colorScheme.primary,
                                barWidth: 3,
                                isStrokeCapRound: true,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn().slideY(begin: 0.1),
              const SizedBox(height: 32),
              GlassPane(
                borderRadius: 32,
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Text(
                      'Exchange Result',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    if (state.isLoading)
                      const CircularProgressIndicator()
                    else ...[
                      Text(
                        state.result.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.displayMedium,
                      ).animate().fadeIn().scale(),
                      Text(
                        state.toCurrency,
                        style: TextStyle(
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38),
                        ),
                      ),
                    ],
                    if (state.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          state.error!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
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
                        Icon(LucideIcons.info, size: 16, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Market Insights',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Exchange rates fluctuate constantly due to global market conditions. These rates are live data provided by ExchangeRate-API. Always verify rates with your financial institution before making large transfers.',
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

class _CurrencyDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _CurrencyDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure value is in items to avoid error
    final safeValue = items.contains(value) ? value : (items.isNotEmpty ? items.first : value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.38)),
        ),
        DropdownButton<String>(
          value: items.isEmpty ? value : safeValue,
          isExpanded: true,
          underline: const SizedBox(),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
          dropdownColor: Theme.of(context).colorScheme.surface.withOpacity(1.0), // Solid for readability
          items: items.isEmpty
              ? [DropdownMenuItem(value: value, child: Text(value))]
              : items.map((currency) {
                  return DropdownMenuItem(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
