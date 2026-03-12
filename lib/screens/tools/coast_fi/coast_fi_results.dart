import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../providers/country_provider.dart';
import 'coast_fi_provider.dart';

class CoastFiResults extends ConsumerWidget {
  const CoastFiResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(coastFiProvider);
    final notifier = ref.read(coastFiProvider.notifier);
    final currencySymbol = ref.watch(countryProvider).currencySymbol;

    final currencyFormat = NumberFormat.compactCurrency(
      symbol: currencySymbol,
      decimalDigits: 2,
    );
    final fullCurrencyFormat = NumberFormat.currency(
      symbol: currencySymbol,
      decimalDigits: 0,
    );

    final requiredCorpus = state.requiredRetirementCorpus;
    final coastNumberToday = state.coastNumberToday;
    final currentTotal = state.advancedMode
        ? state.pension.startingBalance +
            state.isa.startingBalance +
            state.gia.startingBalance
        : state.currentSavings;
    final isCoasting = currentTotal >= coastNumberToday;

    final projection = notifier.computeProjection(advanced: state.advancedMode);
    final retirementRow = projection.firstWhere(
      (row) => row.age == state.retirementAge,
      orElse: () => projection.last,
    );
    final meetsFire = retirementRow.total >= retirementRow.fireNumber;
    final coastRow = projection.firstWhere(
      (row) => row.total >= row.fireNumber,
      orElse: () => projection.last,
    );
    final reachesCoast = coastRow.total >= coastRow.fireNumber;
    final coastAge = reachesCoast ? coastRow.age : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: isCoasting
              ? Colors.green[800]
              : Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isCoasting
                          ? Icons.check_circle_rounded
                          : Icons.info_outline_rounded,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isCoasting ? 'You are Coast FI!' : 'Not yet Coast FI',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Your Coast Number Today:',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 8),
                Text(
                  fullCurrencyFormat.format(coastNumberToday),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  reachesCoast
                      ? 'Coast FI age: ${coastAge!} (portfolio meets FIRE number)'
                      : 'Coast FI age: not reached by ${projection.last.age}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isCoasting
                      ? 'You can stop saving right now! Your current savings of ${fullCurrencyFormat.format(currentTotal)} will naturally grow to your target.'
                      : 'You need ${fullCurrencyFormat.format(coastNumberToday - currentTotal)} more invested today to stop saving forever.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target Corpus',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currencyFormat.format(requiredCorpus),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                          color: const Color(0xFF212121),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Needed by age ${state.retirementAge}',
                        style: const TextStyle(color: Color(0xFF757575)),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 60, color: const Color(0xFFE0E0E0)),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Projected Portfolio at Retirement',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currencyFormat.format(retirementRow.total),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                          color: meetsFire
                              ? Colors.green[800]
                              : const Color(0xFF212121),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meetsFire
                            ? 'Meets FIRE number at ${state.retirementAge}'
                            : 'Below FIRE number at ${state.retirementAge}',
                        style: const TextStyle(color: Color(0xFF757575)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
