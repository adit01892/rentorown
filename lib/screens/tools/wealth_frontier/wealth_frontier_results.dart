import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../providers/country_provider.dart';
import 'wealth_frontier_provider.dart';
import 'wealth_frontier_monte_carlo.dart';

class WealthFrontierResultsAndChart extends ConsumerWidget {
  const WealthFrontierResultsAndChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wealthFrontierProvider);
    final currencySymbol = ref.watch(countryProvider).currencySymbol;

    final currencyFormat = NumberFormat.compactCurrency(
      symbol: currencySymbol,
      decimalDigits: 0,
    );
    final fullFormat = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 0,
    );

    return FutureBuilder<MonteCarloResult>(
      future: runMonteCarloSimulation(state), // Re-runs when state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(48.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Running 2,000 simulations...',
                      style: TextStyle(color: Color(0xFF757575)),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Text('Error running simulation: ${snapshot.error}'),
              ),
            ),
          );
        }

        final result = snapshot.data!;

        List<FlSpot> buildSpots(List<List<double>> path) {
          return path.map((point) => FlSpot(point[0], point[1])).toList();
        }

        final p10Spots = buildSpots(result.p10Path);
        final p50Spots = buildSpots(result.p50Path);
        final p90Spots = buildSpots(result.p90Path);

        double maxY = p90Spots.last.y * 1.1;

        return Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Allocation Strategy',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStrategyDropdown(
                      context,
                      state,
                      ref.read(wealthFrontierProvider.notifier),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
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
                            'Expected Net Worth',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: Colors.white70),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            fullFormat.format(result.finalNetWorth),
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Median Outcome',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.white70),
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
                            'Ending Debt',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: const Color(0xFF757575)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            fullFormat.format(result.finalDebt),
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: result.finalDebt > 0
                                      ? Colors.red
                                      : Colors.green,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Median Outcome',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: const Color(0xFF757575)),
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
                      'Probabilistic Net Worth Trajectory',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 350,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (_) => const FlLine(
                              color: Color(0xFFEEEEEE),
                              strokeWidth: 1,
                            ),
                          ),
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
                                reservedSize: 65,
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
                                reservedSize: 40,
                                getTitlesWidget: (val, meta) {
                                  if (val % 2 != 0 &&
                                      val != state.durationYears.toDouble()) {
                                    return const SizedBox.shrink();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Yr ${val.toInt()}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF757575),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          minX: 0,
                          maxX: state.durationYears.toDouble(),
                          minY: 0,
                          maxY: maxY,
                          lineBarsData: [
                            LineChartBarData(
                              spots: p90Spots,
                              isCurved: true,
                              color: Colors.green.withValues(alpha: 0.5),
                              barWidth: 2,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                            ),
                            LineChartBarData(
                              spots: p10Spots,
                              isCurved: true,
                              color: Colors.red.withValues(alpha: 0.5),
                              barWidth: 2,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: false),
                            ),
                            LineChartBarData(
                              spots: p50Spots,
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
                          ],
                          lineTouchData: LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipColor: (_) => Colors.blueGrey,
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  String label = '';
                                  if (spot.barIndex == 0) {
                                    label = '90th Pct';
                                  } else if (spot.barIndex == 1) {
                                    label = '10th Pct';
                                  } else if (spot.barIndex == 2) {
                                    label = 'Median';
                                  }

                                  final value = currencyFormat.format(spot.y);

                                  if (spot == touchedSpots.first) {
                                    return LineTooltipItem(
                                      'Year ${spot.x.toInt()}\n',
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
                    const Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        _LegendItem(
                          color: Colors.green,
                          text: '90th Percentile (Optimistic)',
                        ),
                        _LegendItem(
                          color: Colors.deepPurple,
                          text: 'Median Expected',
                        ),
                        _LegendItem(
                          color: Colors.red,
                          text: '10th Percentile (Pessimistic)',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStrategyDropdown(
    BuildContext context,
    WealthFrontierState state,
    WealthFrontierNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<WealthStrategy>(
          isExpanded: true,
          value: state.strategy,
          onChanged: (value) {
            if (value != null) notifier.updateStrategy(value);
          },
          items: const [
            DropdownMenuItem(
              value: WealthStrategy.payDebtFirst,
              child: Text('Pay Debt First, then Invest'),
            ),
            DropdownMenuItem(
              value: WealthStrategy.split5050,
              child: Text('Split 50/50'),
            ),
            DropdownMenuItem(
              value: WealthStrategy.investFirst,
              child: Text('Invest Everything (Minimum Debt Payments)'),
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
