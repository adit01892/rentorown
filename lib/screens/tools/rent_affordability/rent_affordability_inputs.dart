import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/country_provider.dart';
import '../../../utils/tooltip_helper.dart';
import 'rent_affordability_provider.dart';

class RentAffordabilityInputs extends ConsumerWidget {
  const RentAffordabilityInputs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rentAffordabilityProvider);
    final notifier = ref.read(rentAffordabilityProvider.notifier);
    final currencySymbol = ref.watch(countryProvider).currencySymbol;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Income & Expenses',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildInputField(
              context,
              label: 'Gross Monthly Income',
              tooltip:
                  'Your total pre-tax monthly income before any deductions.',
              initialValue: state.grossMonthlyIncome,
              currencySymbol: currencySymbol,
              onChanged: (val) => notifier.updateGrossIncome(val),
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Net Monthly Income (After Tax)',
              tooltip:
                  'Your actual take-home pay each month after taxes and deductions.',
              initialValue: state.netMonthlyIncome,
              currencySymbol: currencySymbol,
              onChanged: (val) => notifier.updateNetIncome(val),
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Fixed Monthly Expenses (Loans, Subscriptions, etc.)',
              tooltip:
                  'Mandatory non-housing expenses like debt minimums, phone bills, or transit.',
              initialValue: state.fixedExpenses,
              currencySymbol: currencySymbol,
              onChanged: (val) => notifier.updateFixedExpenses(val),
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Monthly Savings Goals (Retirement, Emergency Fund)',
              tooltip:
                  'How much you commit to putting away or investing each month.',
              initialValue: state.savingsGoals,
              currencySymbol: currencySymbol,
              onChanged: (val) => notifier.updateSavingsGoals(val),
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Discretionary Spending Target (Food, Fun, Travel)',
              tooltip:
                  'Budget allocated for groceries, dining out, and entertainment.',
              initialValue: state.discretionarySpending,
              currencySymbol: currencySymbol,
              onChanged: (val) => notifier.updateDiscretionarySpending(val),
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
          initialValue: initialValue.toStringAsFixed(0),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
          ],
          decoration: InputDecoration(prefixText: '$currencySymbol '),
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
