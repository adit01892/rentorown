import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/country_provider.dart';
import '../../../utils/tooltip_helper.dart';
import 'coast_fi_provider.dart';

class CoastFiInputs extends ConsumerWidget {
  const CoastFiInputs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(coastFiProvider);
    final notifier = ref.read(coastFiProvider.notifier);
    final currencySymbol = ref.watch(countryProvider).currencySymbol;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coast FI Parameters',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildInputField(
              context,
              label: 'Current Age',
              tooltip: 'Your current age in years.',
              initialValue: state.currentAge.toDouble(),
              isCurrency: false,
              currencySymbol: currencySymbol,
              onChanged: (val) => notifier.updateCurrentAge(val.toInt()),
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Target Retirement Age',
              tooltip:
                  'The age at which you plan to fully retire and start drawing down your portfolio.',
              initialValue: state.retirementAge.toDouble(),
              isCurrency: false,
              currencySymbol: currencySymbol,
              onChanged: (val) => notifier.updateRetirementAge(val.toInt()),
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Current Retirement Savings',
              tooltip: 'Total amount already invested for your retirement.',
              initialValue: state.currentSavings,
              currencySymbol: currencySymbol,
              onChanged: notifier.updateCurrentSavings,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Desired Annual Spending in Retirement',
              tooltip:
                  'How much you expect to spend per year in retirement (in today\'s value).',
              initialValue: state.annualSpendingRetirement,
              currencySymbol: currencySymbol,
              onChanged: notifier.updateAnnualSpendingRetirement,
            ),
            const Divider(height: 32),
            Text(
              'Advanced Assumptions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Safe Withdrawal Rate (%)',
              tooltip:
                  'The percentage of your portfolio you can safely withdraw each year in retirement (e.g. 4% rule).',
              initialValue: state.safeWithdrawalRate * 100,
              isCurrency: false,
              currencySymbol: currencySymbol,
              suffixText: '%',
              onChanged: notifier.updateSafeWithdrawalRate,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Expected Real Annual Return (%)',
              tooltip:
                  'Your expected average annual return after accounting for inflation.',
              initialValue: state.expectedAnnualReturn * 100,
              isCurrency: false,
              currencySymbol: currencySymbol,
              suffixText: '%',
              onChanged: notifier.updateExpectedReturn,
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
                  fontSize: 14,
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
