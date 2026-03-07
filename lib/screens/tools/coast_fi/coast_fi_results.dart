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
    final isCoasting = state.isCoasting;

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
                  isCoasting
                      ? 'You can stop saving right now! Your current savings of ${fullCurrencyFormat.format(state.currentSavings)} will naturally grow to your target.'
                      : 'You need ${fullCurrencyFormat.format(coastNumberToday - state.currentSavings)} more invested today to stop saving forever.',
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
                        'Projected Nest Egg',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currencyFormat.format(state.coastingFutureValue),
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: isCoasting
                                  ? Colors.green[800]
                                  : const Color(0xFF212121),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'If you save $currencySymbol 0 more',
                        style: const TextStyle(color: Color(0xFF757575)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Contextual insight
        if (isCoasting && state.currentAge < 40)
          _buildInsightCard(
            context,
            icon: Icons.celebration,
            color: Colors.green,
            text:
                'You\'ve reached Coast FI at age ${state.currentAge}! This means you could switch to a lower-paying passion job and still retire comfortably at ${state.retirementAge}.',
          )
        else if (isCoasting)
          _buildInsightCard(
            context,
            icon: Icons.check_circle_outline,
            color: Colors.green,
            text:
                'You\'ve hit your Coast Number! If you never save another penny, your current savings should grow to cover retirement at your target spending level.',
          )
        else if ((coastNumberToday - state.currentSavings) / coastNumberToday <
            0.20)
          _buildInsightCard(
            context,
            icon: Icons.trending_up,
            color: Colors.orange,
            text:
                'Almost there! You\'re within ${(((coastNumberToday - state.currentSavings) / coastNumberToday) * 100).toStringAsFixed(0)}% of your Coast Number. A small boost in savings could get you across the finish line.',
          )
        else
          _buildInsightCard(
            context,
            icon: Icons.info_outline,
            color: Theme.of(context).colorScheme.primary,
            text:
                'You need ${fullCurrencyFormat.format(coastNumberToday - state.currentSavings)} more to reach your Coast Number. Once you hit it, your savings can grow to your target on autopilot.',
          ),
      ],
    );
  }

  Widget _buildInsightCard(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: color.withValues(alpha: 0.9),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
