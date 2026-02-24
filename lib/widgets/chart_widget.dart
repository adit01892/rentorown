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
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Net Worth Over Time',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Row(
                  children: [
                    _buildLegendItem(
                      'Buying',
                      Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    _buildLegendItem(
                      'Renting',
                      Theme.of(context).colorScheme.secondary,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: maxX,
                  minY: minY < 0 ? minY * 1.1 : minY,
                  maxY: maxY > 0 ? maxY * 1.1 : 10.0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: result.buyNetWorth
                          .map((p) => FlSpot(p.year.toDouble(), p.amount))
                          .toList(),
                      isCurved: false,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: result.rentNetWorth
                          .map((p) => FlSpot(p.year.toDouble(), p.amount))
                          .toList(),
                      isCurved: false,
                      color: Theme.of(context).colorScheme.secondary,
                      barWidth: 3,
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
                              style: const TextStyle(fontSize: 12),
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
                              style: const TextStyle(fontSize: 12),
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
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withAlpha(50),
                        strokeWidth: 1,
                        dashArray: [5, 5],
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withAlpha(200),
                        width: 1,
                      ),
                      left: BorderSide.none,
                      right: BorderSide.none,
                      top: BorderSide.none,
                    ),
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => Colors.white,
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((spot) {
                          final color = spot.bar.color ?? Colors.white;
                          return LineTooltipItem(
                            'Year ${spot.x.toInt()}: ${formatCurrency(spot.y, symbol: country.currencySymbol)}',
                            TextStyle(
                              color: color,
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
