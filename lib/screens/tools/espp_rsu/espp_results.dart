import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../providers/country_provider.dart';
import 'espp_rsu_provider.dart';

class EsppResults extends ConsumerWidget {
  const EsppResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(esppRsuProvider);
    final state = data.espp;
    final currencySymbol = ref.watch(countryProvider).currencySymbol;

    final currencyFormat = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 0,
    );

    final yieldPercentage = (state.effectiveYield * 100).toStringAsFixed(1);
    final isLoss = state.profit < 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Annualized Effective Yield',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  '$yieldPercentage%',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Because your cash is tied up for only a fraction of the year, the effective annualized return is often much higher than the simple discount rate.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Builder(
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.05),
                border: Border.all(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.2),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      state.effectiveYield > 0
                          ? 'This annualized return accounts for the ESPP discount and stock price change. Compare it to your alternative investment return (e.g. index fund ~8%) to decide whether to max out contributions.'
                          : 'The stock price drop exceeded the ESPP discount, resulting in a negative return. Consider whether you expect the stock to recover before deciding on contributions.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF616161),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Purchase Summary',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                _ResultRow(
                  label: 'Purchase Price (per share)',
                  value: NumberFormat.currency(
                    symbol: currencySymbol,
                    decimalDigits: 2,
                  ).format(state.purchasePrice),
                ),
                const Divider(height: 24),
                _ResultRow(
                  label: 'Total Cash Invested',
                  value: currencyFormat.format(state.cashInvested),
                ),
                const Divider(height: 24),
                _ResultRow(
                  label: 'Shares Bought',
                  value: state.sharesBought.toStringAsFixed(2),
                ),
                const Divider(height: 24),
                _ResultRow(
                  label: 'Value at End of Period',
                  value: currencyFormat.format(state.valueAtEnd),
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Profit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      currencyFormat.format(state.profit),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isLoss ? Colors.red : Colors.green[800],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;

  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF616161))),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ],
    );
  }
}
