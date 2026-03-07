import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../providers/country_provider.dart';
import 'coast_fi_provider.dart';

class CoastFiChart extends ConsumerWidget {
  const CoastFiChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(coastFiProvider);
    final currencySymbol = ref.watch(countryProvider).currencySymbol;

    if (state.retirementAge <= state.currentAge) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: Text('Retirement age must be greater than current age.'),
          ),
        ),
      );
    }

    final currencyFormat = NumberFormat.compactCurrency(
      symbol: currencySymbol,
      decimalDigits: 0,
    );
    final yearsToRetirement = state.retirementAge - state.currentAge;

    // Generate data points
    final List<FlSpot> currentSavingsGrowth = [];
    final List<FlSpot> requiredTrajectory = [];

    for (int i = 0; i <= yearsToRetirement; i++) {
      double fvCurrentSavings =
          state.currentSavings * pow(1 + state.expectedAnnualReturn, i);

      // The required amount at year 'i' to hit the corpus by retirement
      double requiredAtI =
          state.requiredRetirementCorpus /
          pow(1 + state.expectedAnnualReturn, yearsToRetirement - i);

      currentSavingsGrowth.add(FlSpot(i.toDouble(), fvCurrentSavings));
      requiredTrajectory.add(FlSpot(i.toDouble(), requiredAtI));
    }

    final maxY =
        max(currentSavingsGrowth.last.y, requiredTrajectory.last.y) * 1.1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Growth Trajectory over Time',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) =>
                        const FlLine(color: Color(0xFFEEEEEE), strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value % 5 != 0 &&
                              value != yearsToRetirement.toDouble()) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Age ${(state.currentAge + value).toInt()}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF757575),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 45,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            currencyFormat.format(value),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF757575),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: yearsToRetirement.toDouble(),
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [
                    // Required Trajectory Line (Dashed / Orange)
                    LineChartBarData(
                      spots: requiredTrajectory,
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                    ),
                    // Your Savings Growth Line (Solid / Primary or Green)
                    LineChartBarData(
                      spots: currentSavingsGrowth,
                      isCurved: true,
                      color: state.isCoasting
                          ? Colors.green
                          : Theme.of(context).colorScheme.primary,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color:
                            (state.isCoasting
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.primary)
                                .withValues(alpha: 0.1),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => Colors.blueGrey,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final label = spot.bar.color == Colors.orange
                              ? 'Required'
                              : 'Projected';
                          final value = NumberFormat.currency(
                            symbol: currencySymbol,
                            decimalDigits: 0,
                          ).format(spot.y);

                          if (spot == touchedSpots.first) {
                            return LineTooltipItem(
                              'Age ${(state.currentAge + spot.x).toInt()}\n',
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
                          return LineTooltipItem(
                            '$label: $value',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          );
                        }).toList();
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
                _LegendItem(
                  color: state.isCoasting
                      ? Colors.green
                      : Theme.of(context).colorScheme.primary,
                  text: 'Your Projected Savings',
                ),
                const SizedBox(width: 24),
                const _LegendItem(
                  color: Colors.orange,
                  text: 'Required Savings (Coast Path)',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Color(0xFF616161),
          ),
        ),
      ],
    );
  }
}
