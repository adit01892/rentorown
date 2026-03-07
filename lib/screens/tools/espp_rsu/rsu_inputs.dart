import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/country_provider.dart';
import '../../../utils/tooltip_helper.dart';
import 'espp_rsu_provider.dart';

class RsuInputs extends ConsumerWidget {
  const RsuInputs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(esppRsuProvider);
    final state = data.rsu;
    final notifier = ref.read(esppRsuProvider.notifier);
    final currencySymbol = ref.watch(countryProvider).currencySymbol;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'RSU Grant Details',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildInputField(
              context,
              label: 'Total Grant Value',
              tooltip:
                  'The total initial dollar value of all Restricted Stock Units granted to you.',
              initialValue: state.totalGrantValue,
              currencySymbol: currencySymbol,
              onChanged: (val) =>
                  notifier.updateRsu(state.copyWith(totalGrantValue: val)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    context,
                    label: 'Duration (Years)',
                    tooltip:
                        'The total length of time until 100% of your grant is vested.',
                    initialValue: state.durationYears,
                    isCurrency: false,
                    currencySymbol: currencySymbol,
                    onChanged: (val) =>
                        notifier.updateRsu(state.copyWith(durationYears: val)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInputField(
                    context,
                    label: 'Cliff (Months)',
                    tooltip:
                        'The time you must wait before the very first portion of your grant vests (typically 12 months).',
                    initialValue: state.cliffMonths,
                    isCurrency: false,
                    currencySymbol: currencySymbol,
                    onChanged: (val) =>
                        notifier.updateRsu(state.copyWith(cliffMonths: val)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Vesting Frequency (Months) e.g., 3 for quarterly',
              tooltip:
                  'How often shares vest *after* the cliff (e.g., 1 for monthly, 3 for quarterly).',
              initialValue: state.vestingFrequencyMonths,
              isCurrency: false,
              currencySymbol: currencySymbol,
              onChanged: (val) {
                if (val > 0) {
                  notifier.updateRsu(
                    state.copyWith(vestingFrequencyMonths: val),
                  );
                }
              },
            ),
            const Divider(height: 32),
            Text(
              'Tax & Growth Assumptions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Estimated Tax Rate (%)',
              tooltip:
                  'RSUs are taxed as ordinary income upon vesting. Enter your estimated combined marginal tax bracket.',
              initialValue: state.estimatedTaxRate,
              isCurrency: false,
              suffixText: '%',
              currencySymbol: currencySymbol,
              onChanged: (val) =>
                  notifier.updateRsu(state.copyWith(estimatedTaxRate: val)),
            ),
            const SizedBox(height: 16),
            _buildInputField(
              context,
              label: 'Expected Annual Stock Growth (%)',
              tooltip:
                  'Your estimate for how much the company\'s stock will appreciate annually during the vesting period.',
              initialValue: state.expectedStockGrowth,
              isCurrency: false,
              suffixText: '%',
              currencySymbol: currencySymbol,
              onChanged: (val) =>
                  notifier.updateRsu(state.copyWith(expectedStockGrowth: val)),
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
