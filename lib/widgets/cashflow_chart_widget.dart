import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/simulation_provider.dart';
import '../providers/country_provider.dart';
import '../utils/formatters.dart';

class CashflowChartWidget extends ConsumerWidget {
  const CashflowChartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(simulationResultProvider);
    final country = ref.watch(countryProvider);
    final buyCF = result.buyCashFlow;
    final rentCF = result.rentCashFlow;

    final List<double> ongoingValues = [];
    if (buyCF.length > 1) {
      ongoingValues.addAll(buyCF.sublist(0, buyCF.length));
      ongoingValues.addAll(rentCF.sublist(0, rentCF.length));
    } else {
      ongoingValues.addAll([...buyCF, ...rentCF]);
    }

    final double maxVal = ongoingValues.isEmpty
        ? 0
        : ongoingValues.reduce((a, b) => a > b ? a : b);
    final double minVal = ongoingValues.isEmpty
        ? 0
        : ongoingValues.reduce((a, b) => a < b ? a : b);

    final double yMax = (maxVal > 0 ? maxVal * 1.15 : 0);
    final double yMin = minVal < 0 ? minVal * 1.15 : 0;

    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    final barGroups = <BarChartGroupData>[];
    for (int i = 0; i < buyCF.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: buyCF[i],
              color: buyCF[i] >= 0
                  ? primaryColor
                  : primaryColor.withValues(alpha: 0.6),
              width: 10,
              borderRadius: buyCF[i] >= 0
                  ? const BorderRadius.vertical(top: Radius.circular(4))
                  : const BorderRadius.vertical(bottom: Radius.circular(4)),
            ),
            BarChartRodData(
              toY: rentCF[i],
              color: rentCF[i] >= 0
                  ? secondaryColor
                  : secondaryColor.withValues(alpha: 0.6),
              width: 10,
              borderRadius: rentCF[i] >= 0
                  ? const BorderRadius.vertical(top: Radius.circular(4))
                  : const BorderRadius.vertical(bottom: Radius.circular(4)),
            ),
          ],
          barsSpace: 4,
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cashflow Comparison',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Row(
                  children: [
                    _buildLegendItem('Buying', primaryColor),
                    const SizedBox(width: 16),
                    _buildLegendItem('Renting', secondaryColor),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Annual cashflows — final year includes net worth returned as cash',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFF9E9E9E)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: yMax,
                  minY: yMin,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => const Color(0xFF1A1A2E),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final label = rodIndex == 0 ? 'Buy' : 'Rent';
                        final value = formatCurrency(
                          rod.toY,
                          symbol: country.currencySymbol,
                        );

                        if (rodIndex == 0) {
                          return BarTooltipItem(
                            'Year $groupIndex\n',
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: '$label: $value',
                                style: TextStyle(
                                  color: rod.color ?? Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        }

                        return BarTooltipItem(
                          '$label: $value',
                          TextStyle(
                            color: rod.color ?? Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          // Only show every other year to avoid crowding
                          if (idx % 2 != 0 && buyCF.length > 8) {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              'Yr $idx',
                              style: const TextStyle(fontSize: 11),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 72,
                        getTitlesWidget: (value, meta) {
                          if (value == meta.max || value == meta.min) {
                            return const SizedBox.shrink();
                          }
                          return SideTitleWidget(
                            meta: meta,
                            child: Text(
                              formatCurrency(
                                value,
                                symbol: country.currencySymbol,
                              ),
                              style: const TextStyle(fontSize: 11),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: (yMax - yMin) / 5,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: const Color(0xFFE0E0E0), strokeWidth: 1),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      bottom: BorderSide(color: Color(0xFFE0E0E0)),
                      left: BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                  ),
                  // Zero line
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: 0,
                        color: const Color(0xFF9E9E9E),
                        strokeWidth: 1.5,
                        dashArray: [4, 4],
                      ),
                    ],
                  ),
                  barGroups: barGroups,
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
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
