import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/simulation_provider.dart';
import '../providers/country_provider.dart';
import '../utils/formatters.dart';

class ChartWidget extends ConsumerWidget {
  const ChartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(simulationResultProvider);
    final country = ref.watch(countryProvider);

    double maxY = 0;
    for (var p in result.buyNetWorth) {
      if (p.amount > maxY) maxY = p.amount;
    }
    for (var p in result.rentNetWorth) {
      if (p.amount > maxY) maxY = p.amount;
    }

    double minY = 0;
    for (var p in result.buyNetWorth) {
      if (p.amount < minY) minY = p.amount;
    }
    for (var p in result.rentNetWorth) {
      if (p.amount < minY) minY = p.amount;
    }

    final maxX = result.buyNetWorth.isNotEmpty
        ? result.buyNetWorth.last.year.toDouble()
        : 10.0;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Net Worth Over Time',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 320,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: maxX * 1.05,
                  minY: minY < 0 ? minY * 1.1 : minY,
                  maxY: maxY > 0 ? maxY * 1.1 : 10.0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: result.buyNetWorth
                          .map((p) => FlSpot(p.year.toDouble(), p.amount))
                          .toList(),
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                      ),
                    ),
                    LineChartBarData(
                      spots: result.rentNetWorth
                          .map((p) => FlSpot(p.year.toDouble(), p.amount))
                          .toList(),
                      isCurved: true,
                      color: Theme.of(context).colorScheme.secondary,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      axisNameWidget: const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Text('Years', style: TextStyle(fontSize: 12)),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              value.toInt().toString(),
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
                      axisNameWidget: const Text('Net Worth'),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 80,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              formatCurrency(
                                value,
                                symbol: country.currencySymbol,
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF757575),
                              ),
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: Color(0xFFEEEEEE),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => const Color(0xFF1E1E2C),
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((spot) {
                          final color = spot.bar.color ?? Colors.white;
                          final label = spot.barIndex == 0 ? 'Buy' : 'Rent';
                          final value = formatCurrency(
                            spot.y,
                            symbol: country.currencySymbol,
                          );

                          if (spot == touchedSpots.first) {
                            return LineTooltipItem(
                              'Year ${spot.x.toInt()}\n',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              children: [
                                TextSpan(
                                  text: '$label: $value',
                                  style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            );
                          }
                          return LineTooltipItem(
                            '$label: $value',
                            TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
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
                _buildLegendItem(
                  'Buying',
                  Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 24),
                _buildLegendItem(
                  'Renting',
                  Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
