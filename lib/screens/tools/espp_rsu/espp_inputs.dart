import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/country_provider.dart';
import '../../../utils/tooltip_helper.dart';
import 'espp_rsu_provider.dart';

class EsppInputs extends ConsumerWidget {
  const EsppInputs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(esppRsuProvider);
    final state = data.espp;
    final notifier = ref.read(esppRsuProvider.notifier);
    final currencySymbol = ref.watch(countryProvider).currencySymbol;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ESPP Parameters',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildInputField(
              context,
              label: 'Gross Annual Salary',
              tooltip: 'Your total pre-tax annual income.',
              initialValue: state.grossIncome,
              currencySymbol: currencySymbol,
              onChanged: (val) =>
                  notifier.updateEspp(state.copyWith(grossIncome: val)),
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Salary Contribution (%)',
              tooltip:
                  'The percentage of your paycheck you elect to use to purchase ESPP shares.',
              initialValue: state.contributionPercentage,
              isCurrency: false,
              suffixText: '%',
              currencySymbol: currencySymbol,
              onChanged: (val) => notifier.updateEspp(
                state.copyWith(contributionPercentage: val),
              ),
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Offering Period (Months)',
              tooltip:
                  'The length of time over which your payroll contributions accumulate before shares are purchased.',
              initialValue: state.offeringPeriodMonths,
              isCurrency: false,
              currencySymbol: currencySymbol,
              onChanged: (val) => notifier.updateEspp(
                state.copyWith(offeringPeriodMonths: val),
              ),
            ),
            const Divider(height: 32),
            Text(
              'Stock Assumptions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Discount Rate (%)',
              tooltip:
                  'The discount your company offers on the purchase price (usually up to 15%).',
              initialValue: state.discountPercentage,
              isCurrency: false,
              suffixText: '%',
              currencySymbol: currencySymbol,
              onChanged: (val) =>
                  notifier.updateEspp(state.copyWith(discountPercentage: val)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Lookback Provision',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF616161),
                    ),
                  ),
                ),
                buildInfoTooltip(
                  'If enabled, the discount is applied to the lower of the start price or end price. This acts as a floor and significantly boosts returns in down markets.',
                ),
                Switch(
                  value: state.hasLookback,
                  onChanged: (val) =>
                      notifier.updateEspp(state.copyWith(hasLookback: val)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Expected Start Price',
              tooltip:
                  'Your estimate for the stock price at the beginning of the offering period.',
              initialValue: state.startPrice,
              currencySymbol: currencySymbol,
              onChanged: (val) =>
                  notifier.updateEspp(state.copyWith(startPrice: val)),
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Expected End Price',
              tooltip:
                  'Your estimate for the stock price at the end of the offering period (purchase date).',
              initialValue: state.endPrice,
              currencySymbol: currencySymbol,
              onChanged: (val) =>
                  notifier.updateEspp(state.copyWith(endPrice: val)),
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
