import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/country_provider.dart';
import '../../../utils/tooltip_helper.dart';
import 'wealth_frontier_provider.dart';

class WealthFrontierInputs extends ConsumerWidget {
  const WealthFrontierInputs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wealthFrontierProvider);
    final notifier = ref.read(wealthFrontierProvider.notifier);
    final currencySymbol = ref.watch(countryProvider).currencySymbol;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Financial Snapshot',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildInputField(
              context,
              label: 'Current Investments/Savings',
              tooltip:
                  'Total liquid and invested assets (e.g. brokerage, savings, retirement accounts).',
              initialValue: state.currentSavings,
              currencySymbol: currencySymbol,
              onChanged: notifier.updateSavings,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Current Outstanding Debt',
              tooltip:
                  'Total remaining principal on your debt (e.g. mortgage, student loans, car loan).',
              initialValue: state.currentDebt,
              currencySymbol: currencySymbol,
              onChanged: notifier.updateDebt,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    context,
                    label: 'Required Min. Debt Payment',
                    tooltip:
                        'The mandatory minimum monthly payment required to keep your debt in good standing.',
                    initialValue: state.minimumDebtPayment,
                    currencySymbol: currencySymbol,
                    onChanged: notifier.updateMinimumDebtPayment,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    context,
                    label: 'Extra Monthly Cash',
                    tooltip:
                        'Total discretionary cash left over each month *after* paying living expenses, which can be used to pay the minimum debt payment, invest, or make extra debt payments.',
                    initialValue: state.extraMonthlyCash,
                    currencySymbol: currencySymbol,
                    onChanged: notifier.updateMonthlyCash,
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Text('Assumptions', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    context,
                    label: 'Debt Interest Rate (%)',
                    tooltip:
                        'The annual percentage rate (APR) of your outstanding debt.',
                    initialValue: state.debtInterestRate,
                    isCurrency: false,
                    currencySymbol: currencySymbol,
                    suffixText: '%',
                    onChanged: notifier.updateDebtRate,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    context,
                    label: 'Expected Return (%)',
                    tooltip:
                        'The long-term average annual return you expect from your investments.',
                    initialValue: state.expectedReturn,
                    isCurrency: false,
                    currencySymbol: currencySymbol,
                    suffixText: '%',
                    onChanged: notifier.updateExpectedReturn,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    context,
                    label: 'Return Volatility (%)',
                    tooltip:
                        'The standard deviation of your expected returns. Higher implies more risk (e.g., 15-20% for stocks, 5% for bonds).',
                    initialValue: state.returnVolatility,
                    isCurrency: false,
                    currencySymbol: currencySymbol,
                    suffixText: '%',
                    onChanged: notifier.updateVolatility,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    context,
                    label: 'Simulation Years',
                    tooltip:
                        'How many years into the future you want to project these scenarios.',
                    initialValue: state.durationYears.toDouble(),
                    isCurrency: false,
                    currencySymbol: currencySymbol,
                    onChanged: (v) => notifier.updateDuration(v.toInt()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required String label,
    required String tooltip,
    required double initialValue,
    required ValueChanged<double> onChanged,
    required String currencySymbol,
    bool isCurrency = true,
    String? suffixText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF616161),
                ),
              ),
            ),
            buildInfoTooltip(tooltip),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue
              .toStringAsFixed(isCurrency ? 0 : 2)
              .replaceAll('.00', ''),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
          ],
          decoration: InputDecoration(
            prefixText: isCurrency ? '$currencySymbol ' : null,
            suffixText: suffixText,
          ),
          onChanged: (value) {
            final parsed = double.tryParse(value);
            if (parsed != null) {
              onChanged(parsed);
            }
          },
        ),
      ],
    );
  }
}
