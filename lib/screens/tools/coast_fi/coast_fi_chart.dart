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
    final notifier = ref.read(coastFiProvider.notifier);
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

    if (state.advancedMode) {
      final projection = notifier.computeProjection(advanced: true);
      return _buildAdvancedChart(
        context,
        projection: projection,
        currencyFormat: currencyFormat,
      );
    }

    final projection = notifier.computeProjection(advanced: false);
    final minAge = projection.first.age;
    final maxAge = projection.last.age;

    final List<FlSpot> projected = [];
    final List<FlSpot> fireLine = [];
    final List<FlSpot> requiredTrajectory = [];

    for (final row in projection) {
      projected.add(FlSpot(row.age.toDouble(), row.total));
      fireLine.add(FlSpot(row.age.toDouble(), row.fireNumber));
    }

    if (state.monthlySavings == 0) {
      final yearsToRetirement = state.retirementAge - state.currentAge;
      for (int i = 0; i <= yearsToRetirement; i++) {
        final requiredAtI =
            state.requiredRetirementCorpus /
            pow(1 + (state.expectedAnnualReturn / 100), yearsToRetirement - i);
        requiredTrajectory.add(
          FlSpot((state.currentAge + i).toDouble(), requiredAtI),
        );
      }
    }

    double maxY = 0;
    for (final spot in projected) {
      maxY = max(maxY, spot.y);
    }
    for (final spot in fireLine) {
      maxY = max(maxY, spot.y);
    }
    for (final spot in requiredTrajectory) {
      maxY = max(maxY, spot.y);
    }
    maxY *= 1.1;

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
              height: 320,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) =>
                        const FlLine(color: Color(0xFFEEEEEE), strokeWidth: 1),
                  ),
                  titlesData: _advancedTitles(
                    currencyFormat: currencyFormat,
                    minAge: minAge,
                    maxAge: maxAge,
                  ),
                  borderData: FlBorderData(show: false),
                  minX: minAge.toDouble(),
                  maxX: maxAge.toDouble(),
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [
                    LineChartBarData(
                      spots: projected,
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
                    if (requiredTrajectory.isNotEmpty)
                      LineChartBarData(
                        spots: requiredTrajectory,
                        isCurved: true,
                        color: Colors.orange,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                      ),
                    LineChartBarData(
                      spots: fireLine,
                      isCurved: false,
                      color: const Color(0xFF7C7C7C),
                      barWidth: 2,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      dashArray: [6, 4],
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => const Color(0xFF1E1E2C),
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final label = spot.bar.color == Colors.orange
                              ? 'Required'
                              : spot.bar.color == const Color(0xFF7C7C7C)
                                  ? 'FIRE Number'
                                  : 'Projected';
                          final value = NumberFormat.currency(
                            symbol: currencySymbol,
                            decimalDigits: 0,
                          ).format(spot.y);

                          final textColor = label == 'FIRE Number'
                              ? Colors.white
                              : (spot.bar.color ?? Colors.white);
                          return LineTooltipItem(
                            'Age ${spot.x.toInt()}\n$label: $value',
                            TextStyle(
                              color: textColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
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
                if (requiredTrajectory.isNotEmpty) ...[
                  const _LegendItem(
                    color: Colors.orange,
                    text: 'Required Savings (Coast Path)',
                  ),
                  const SizedBox(width: 24),
                ],
                const _LegendItem(
                  color: Color(0xFF7C7C7C),
                  text: 'FIRE Number',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedChart(
    BuildContext context, {
    required List<ProjectionYear> projection,
    required NumberFormat currencyFormat,
  }) {
    final ages = projection.map((e) => e.age).toList();
    final minAge = ages.first;
    final maxAge = ages.last;

    final pensionSpots = <FlSpot>[];
    final isaSpots = <FlSpot>[];
    final giaSpots = <FlSpot>[];
    final totalSpots = <FlSpot>[];
    final fireSpots = <FlSpot>[];

    double maxY = 0;
    for (final row in projection) {
      pensionSpots.add(FlSpot(row.age.toDouble(), row.pension));
      isaSpots.add(FlSpot(row.age.toDouble(), row.isa));
      giaSpots.add(FlSpot(row.age.toDouble(), row.gia));
      totalSpots.add(FlSpot(row.age.toDouble(), row.total));
      fireSpots.add(FlSpot(row.age.toDouble(), row.fireNumber));
      maxY = max(maxY, row.total);
      maxY = max(maxY, row.fireNumber);
    }

    maxY *= 1.1;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Portfolio Projection',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 320,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) =>
                        const FlLine(color: Color(0xFFEEEEEE), strokeWidth: 1),
                  ),
                  titlesData: _advancedTitles(
                    currencyFormat: currencyFormat,
                    minAge: minAge,
                    maxAge: maxAge,
                  ),
                  borderData: FlBorderData(show: false),
                  minX: minAge.toDouble(),
                  maxX: maxAge.toDouble(),
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [
                    _areaLine(
                      pensionSpots,
                      const Color(0xFF8FD2A1),
                      'Pension',
                    ),
                    _areaLine(
                      isaSpots,
                      const Color(0xFF8D92FF),
                      'ISA',
                    ),
                    _areaLine(
                      giaSpots,
                      const Color(0xFFFFC27A),
                      'GIA',
                    ),
                    LineChartBarData(
                      spots: totalSpots,
                      isCurved: true,
                      color: const Color(0xFF9E9E9E),
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: fireSpots,
                      isCurved: false,
                      color: const Color(0xFF2D2D2D),
                      barWidth: 2,
                      dotData: const FlDotData(show: false),
                      dashArray: [6, 4],
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => const Color(0xFF1E1E2C),
                      getTooltipItems: (touchedSpots) {
                        final items = <LineTooltipItem>[];
                        for (final spot in touchedSpots) {
                          final value = NumberFormat.currency(
                            symbol: currencyFormat.currencySymbol,
                            decimalDigits: 0,
                          ).format(spot.y);
                          final label = spot.bar.color == const Color(0xFF2D2D2D)
                              ? 'FIRE Number'
                              : spot.bar.color == const Color(0xFF9E9E9E)
                                  ? 'Total'
                                  : spot.bar.color == const Color(0xFF8FD2A1)
                                      ? 'Pension'
                                      : spot.bar.color ==
                                              const Color(0xFF8D92FF)
                                          ? 'ISA'
                                          : 'GIA';
                          final textColor = label == 'FIRE Number'
                              ? Colors.white
                              : (spot.bar.color ?? Colors.white);
                          items.add(
                            LineTooltipItem(
                              '$label: $value',
                              TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return items;
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                _LegendItem(color: Color(0xFF8FD2A1), text: 'Pension'),
                SizedBox(width: 16),
                _LegendItem(color: Color(0xFF8D92FF), text: 'ISA'),
                SizedBox(width: 16),
                _LegendItem(color: Color(0xFFFFC27A), text: 'GIA'),
                SizedBox(width: 16),
                _LegendItem(color: Color(0xFF9E9E9E), text: 'Total'),
                SizedBox(width: 16),
                _LegendItem(color: Color(0xFF2D2D2D), text: 'FIRE Number'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartBarData _areaLine(List<FlSpot> spots, Color color, String label) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 2,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        color: color.withValues(alpha: 0.2),
      ),
    );
  }

  FlTitlesData _simpleTitles({
    required NumberFormat currencyFormat,
    required int currentAge,
    required int years,
  }) {
    return FlTitlesData(
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
            if (value % 5 != 0 && value != years.toDouble()) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Age ${(currentAge + value).toInt()}',
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
    );
  }

  FlTitlesData _advancedTitles({
    required NumberFormat currencyFormat,
    required int minAge,
    required int maxAge,
  }) {
    return FlTitlesData(
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
            if ((value - minAge) % 5 != 0 && value != maxAge.toDouble()) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Age ${value.toInt()}',
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
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
        ),
      ],
    );
  }
}
