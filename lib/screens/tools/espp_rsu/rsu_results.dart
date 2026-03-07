import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../providers/country_provider.dart';
import 'espp_rsu_provider.dart';

class RsuResultsAndChart extends ConsumerWidget {
  const RsuResultsAndChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(esppRsuProvider);
    final state = data.rsu;
    final currencySymbol = ref.watch(countryProvider).currencySymbol;

    final currencyFormat = NumberFormat.compactCurrency(
      symbol: currencySymbol,
      decimalDigits: 0,
    );

    // Calculate Vesting Schedule
    final totalMonths = (state.durationYears * 12).toInt();
    final cliff = state.cliffMonths.toInt();
    final freq = state.vestingFrequencyMonths.toInt();

    if (freq <= 0 || totalMonths <= 0) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('Invalid duration or frequency.'),
        ),
      );
    }

    double totalPreTax = 0;
    double totalPostTax = 0;
    List<BarChartGroupData> barGroups = [];

    // Simulate each month
    for (int month = 1; month <= totalMonths; month++) {
      if (month < cliff) continue; // Before cliff

      bool isVestMonth = false;
      double proportionToVest = 0;

      if (month == cliff) {
        isVestMonth = true;
        proportionToVest = cliff / totalMonths;
      } else if ((month - cliff) % freq == 0) {
        isVestMonth = true;
        proportionToVest = freq / totalMonths;
      }

      if (isVestMonth) {
        final yearsPassed = month / 12;
        final growthMultiplier = pow(
          1 + (state.expectedStockGrowth / 100),
          yearsPassed,
        ).toDouble();
        final preTaxVest =
            state.totalGrantValue * proportionToVest * growthMultiplier;
        final postTaxVest = preTaxVest * (1 - (state.estimatedTaxRate / 100));

        totalPreTax += preTaxVest;
        totalPostTax += postTaxVest;

        barGroups.add(
          BarChartGroupData(
            x: month,
            barRods: [
              BarChartRodData(
                toY: preTaxVest,
                color: Colors.grey[300],
                width: 16,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              BarChartRodData(
                toY: postTaxVest,
                color: Theme.of(context).colorScheme.primary,
                width: 16,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ],
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Value (Post-Tax)',
                        style: Theme.of(
                          context,
                        ).textTheme.titleSmall?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        NumberFormat.currency(
                          symbol: currencySymbol,
                          decimalDigits: 0,
                        ).format(totalPostTax),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Value (Pre-Tax)',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF757575),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        NumberFormat.currency(
                          symbol: currencySymbol,
                          decimalDigits: 0,
                        ).format(totalPreTax),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cash Flow Timeline',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            getTitlesWidget: (val, meta) => Text(
                              currencyFormat.format(val),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF757575),
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (val, meta) => Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Mo ${val.toInt()}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF757575),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (_) => const FlLine(
                          color: Color(0xFFEEEEEE),
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: barGroups,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => Colors.blueGrey,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            final label = rod.color == Colors.grey[300]
                                ? 'Pre-Tax'
                                : 'Post-Tax';
                            final value = NumberFormat.currency(
                              symbol: currencySymbol,
                              decimalDigits: 0,
                            ).format(rod.toY);
                            if (rodIndex == 0) {
                              return BarTooltipItem(
                                'Month ${group.x.toInt()}\n',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                children: [
                                  TextSpan(
                                    text: '$label: $value',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              );
                            }
                            return BarTooltipItem(
                              '$label: $value',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Post-Tax',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF616161),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Container(width: 12, height: 12, color: Colors.grey[300]),
                    const SizedBox(width: 8),
                    const Text(
                      'Pre-Tax',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF616161),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
