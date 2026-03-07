import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../providers/country_provider.dart';
import 'rent_affordability_provider.dart';

class RentAffordabilityResults extends ConsumerWidget {
  const RentAffordabilityResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(rentAffordabilityProvider);
    final currencySymbol = ref.watch(countryProvider).currencySymbol;
    final currencyFormat = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 0,
    );

    final maxRent = state.maxAffordableRent;
    final recommendedRent = state.recommendedRent;

    // Safety boundaries
    final isStressed = recommendedRent < 0;

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
                  'Recommended Rent Target',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  isStressed
                      ? 'Budget Deficit'
                      : currencyFormat.format(recommendedRent),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isStressed
                      ? 'Your current expenses and savings goals exceed your net income.'
                      : 'This leaves ${currencyFormat.format(state.discretionarySpending)} for guilt-free spending.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Absolute Maximum Rent',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  currencyFormat.format(maxRent),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: maxRent < 0 ? Colors.red : const Color(0xFF212121),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'If you pay this much, your discretionary budget will be completely wiped out ($currencySymbol 0 remaining). You will only be able to afford fixed expenses and your savings goals.',
                  style: const TextStyle(color: Color(0xFF757575), height: 1.5),
                ),
                const Divider(height: 32),
                Text(
                  'Comparison to "Rule of Thumb"',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                Builder(
                  builder: (context) {
                    final message = state.rule30PercentGross > maxRent
                        ? "Using the 30% rule would cause you to fail your savings goals or take on debt."
                        : "You can comfortably afford the 30% rule!";
                    return Text(
                      'The standard 30% of gross income rule suggests paying ${currencyFormat.format(state.rule30PercentGross)}. $message',
                      style: const TextStyle(
                        color: Color(0xFF757575),
                        height: 1.5,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
