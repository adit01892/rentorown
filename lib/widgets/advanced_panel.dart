import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/simulation_provider.dart';
import '../utils/tooltip_helper.dart';

class AdvancedPanelWidget extends ConsumerWidget {
  const AdvancedPanelWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(simulationConfigProvider);
    final notifier = ref.read(simulationConfigProvider.notifier);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: const Text('Advanced Settings'),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buy Scenario Assumptions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSliderRow(
                  context: context,
                  label: 'Mortgage Rate',
                  tooltip:
                      'The annual interest rate charged on your loan.\n\nTypical: 4% - 6%.\nImpact: Directly increases the monthly cost of borrowing and reduces the speed at which you build equity.',
                  value: config.interestRate,
                  min: 0,
                  max: 15,
                  divisions: 150,
                  valueLabel: '${config.interestRate.toStringAsFixed(1)}%',
                  onChanged: (val) => notifier.updateConfig(
                    config.copyWith(
                      interestRate: double.parse(val.toStringAsFixed(1)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildSliderRow(
                  context: context,
                  label: 'Mortgage Term',
                  tooltip:
                      'The amount of time you have to pay off the loan in full.\n\nTypical: 25 - 35 years.\nImpact: A longer term lowers monthly payments but increases the total interest paid over the life of the loan.',
                  value: config.mortgageTermYears.toDouble(),
                  min: 5,
                  max: 40,
                  divisions: 35,
                  valueLabel: '${config.mortgageTermYears} Years',
                  onChanged: (val) => notifier.updateConfig(
                    config.copyWith(mortgageTermYears: val.toInt()),
                  ),
                ),
                const SizedBox(height: 8),
                _buildSliderRow(
                  context: context,
                  label: 'Property Growth Rate',
                  tooltip:
                      'The expected annual appreciation of the property\'s overall value.\n\nTypical: 2% - 5%\nImpact: Due to leverage (your mortgage), a 5% increase in property value produces a massively outsized return on your initial cash deposit.',
                  value: config.propertyGrowthRate,
                  min: -5,
                  max: 15,
                  divisions: 200,
                  valueLabel:
                      '${config.propertyGrowthRate.toStringAsFixed(1)}%',
                  onChanged: (val) => notifier.updateConfig(
                    config.copyWith(
                      propertyGrowthRate: double.parse(val.toStringAsFixed(1)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildSliderRow(
                  context: context,
                  label: 'One-Time Buying Costs',
                  tooltip:
                      'Additional upfront costs when purchasing, as a % of property price (legal fees, surveys, conveyancing etc., on top of stamp duty).\n\nTypical: 1% - 3%\nImpact: These are fully sunk at purchase and give the renter extra capital to invest from day one.',
                  value: config.buyingCostsPercentage,
                  min: 0,
                  max: 5,
                  divisions: 50,
                  valueLabel:
                      '${config.buyingCostsPercentage.toStringAsFixed(1)}%',
                  onChanged: (val) => notifier.updateConfig(
                    config.copyWith(
                      buyingCostsPercentage: double.parse(
                        val.toStringAsFixed(1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildSliderRow(
                  context: context,
                  label: 'One-Time Selling Costs',
                  tooltip:
                      'Costs incurred when selling the property at the end of the time horizon, as a % of property value (estate agent fees, legal fees etc.).\n\nTypical: 1% - 3%\nImpact: Reduces the final net worth of the Buy scenario, often the most overlooked cost in property decisions.',
                  value: config.sellingCostsPercentage,
                  min: 0,
                  max: 5,
                  divisions: 50,
                  valueLabel:
                      '${config.sellingCostsPercentage.toStringAsFixed(1)}%',
                  onChanged: (val) => notifier.updateConfig(
                    config.copyWith(
                      sellingCostsPercentage: double.parse(
                        val.toStringAsFixed(1),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Text(
                  'Rent Scenario Assumptions',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSliderRow(
                  context: context,
                  label: 'Expected Investment Return',
                  tooltip:
                      'The annual percentage yield you expect to earn investing your surplus cash in the stock market (e.g., S&P 500 ETF).\n\nTypical: 5% - 10%\nImpact: If this rate is high compared to property growth, renting becomes a much more attractive path to wealth.',
                  value: config.investmentReturn,
                  min: 0,
                  max: 15,
                  divisions: 150,
                  valueLabel: '${config.investmentReturn.toStringAsFixed(1)}%',
                  onChanged: (val) => notifier.updateConfig(
                    config.copyWith(
                      investmentReturn: double.parse(val.toStringAsFixed(1)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildSliderRow(
                  context: context,
                  label: 'Annual Rent Inflation',
                  tooltip:
                      'The expected yearly percentage increase in your rent.\n\nTypical: 2% - 4%\nImpact: Compounds dramatically over long durations, making renting progressively more expensive compared to a fixed-rate mortgage.',
                  value: config.annualRentInflation,
                  min: 0,
                  max: 10,
                  divisions: 100,
                  valueLabel:
                      '${config.annualRentInflation.toStringAsFixed(1)}%',
                  onChanged: (val) => notifier.updateConfig(
                    config.copyWith(
                      annualRentInflation: double.parse(val.toStringAsFixed(1)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow({
    required BuildContext context,
    required String label,
    required String tooltip,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String valueLabel,
    required ValueChanged<double> onChanged,
  }) {
    double safeValue = value;
    if (safeValue > max) safeValue = max;
    if (safeValue < min) safeValue = min;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 4),
                  buildInfoTooltip(tooltip),
                ],
              ),
              Text(
                valueLabel,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: safeValue,
            min: min,
            max: max,
            divisions: divisions > 0 ? divisions : null,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
