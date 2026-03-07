import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../providers/country_provider.dart';
import 'rent_affordability_provider.dart';

class RentAffordabilityChart extends ConsumerWidget {
  const RentAffordabilityChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rentAffordabilityProvider);
    final currencySymbol = ref.watch(countryProvider).currencySymbol;
    final currencyFormat = NumberFormat.compactCurrency(
      symbol: currencySymbol,
      decimalDigits: 0,
    );

    final rent = state.recommendedRent > 0 ? state.recommendedRent : 0.0;
    final fixed = state.fixedExpenses;
    final savings = state.savingsGoals;
    final discretionary = state.discretionarySpending;

    // Don't chart negative values properly, just show 0
    final hasData = rent > 0 || fixed > 0 || savings > 0 || discretionary > 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Net Income Breakdown',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 300,
              child: hasData
                  ? PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 60,
                        sections: [
                          PieChartSectionData(
                            color: Theme.of(context).colorScheme.primary,
                            value: rent,
                            title: currencyFormat.format(rent),
                            radius: 60,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.orange,
                            value: fixed,
                            title: currencyFormat.format(fixed),
                            radius: 60,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.green,
                            value: savings,
                            title: currencyFormat.format(savings),
                            radius: 60,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.purple,
                            value: discretionary,
                            title: currencyFormat.format(discretionary),
                            radius: 60,
                            titleStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(child: Text('Not enough data to chart.')),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _Indicator(
                  color: Theme.of(context).colorScheme.primary,
                  text: 'Rent',
                ),
                const _Indicator(color: Colors.orange, text: 'Fixed Expenses'),
                const _Indicator(color: Colors.green, text: 'Savings Goal'),
                const _Indicator(color: Colors.purple, text: 'Discretionary'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const _Indicator({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
