import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/simulation_provider.dart';
import '../providers/country_provider.dart';
import '../utils/formatters.dart';

class HeadlineResultWidget extends ConsumerWidget {
  const HeadlineResultWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(simulationResultProvider);
    final country = ref.watch(countryProvider);
    final config = ref.watch(simulationConfigProvider);
    final duration = config.durationYears;
    final difference = result.finalDifference;
    final isBuyingBetter = difference > 0;
    final absDiffStr = formatCurrency(
      difference.abs(),
      symbol: country.currencySymbol,
    );

    final buyFinal = result.buyNetWorth.isNotEmpty
        ? result.buyNetWorth.last.amount
        : 0.0;
    final rentFinal = result.rentNetWorth.isNotEmpty
        ? result.rentNetWorth.last.amount
        : 0.0;

    final buyStr = formatCurrency(buyFinal, symbol: country.currencySymbol);
    final rentStr = formatCurrency(rentFinal, symbol: country.currencySymbol);

    String breakevenStr = 'Never';
    if (result.breakevenYear != null && result.breakevenYear! > 0) {
      breakevenStr = 'Year ${result.breakevenYear}';
    } else if (result.breakevenYear == 0) {
      breakevenStr = 'Immediate';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double cardWidth = constraints.maxWidth > 600
              ? (constraints.maxWidth - 48) / 4
              : (constraints.maxWidth - 16) / 2;

          return Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _buildMetricCard(
                context,
                'Buy Scenario',
                buyStr,
                'Est. net worth after $duration years if you buy',
                cardWidth,
                Theme.of(context).colorScheme.primary,
                trailingIcon: buyFinal > rentFinal
                    ? const Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                        size: 16,
                      )
                    : const Icon(
                        Icons.arrow_downward,
                        color: Colors.red,
                        size: 16,
                      ),
              ),
              _buildMetricCard(
                context,
                'Rent Scenario',
                rentStr,
                'Est. net worth after $duration years if you rent',
                cardWidth,
                Theme.of(context).colorScheme.secondary,
                trailingIcon: rentFinal > buyFinal
                    ? const Icon(
                        Icons.arrow_upward,
                        color: Colors.green,
                        size: 16,
                      )
                    : const Icon(
                        Icons.arrow_downward,
                        color: Colors.red,
                        size: 16,
                      ),
              ),
              _buildMetricCard(
                context,
                'Difference',
                absDiffStr,
                isBuyingBetter
                    ? 'Buying outperforms renting after $duration years'
                    : 'Renting outperforms buying after $duration years',
                cardWidth,
                isBuyingBetter ? Colors.green[700] : Colors.red[700],
              ),
              _buildMetricCard(
                context,
                'Breakeven',
                breakevenStr,
                'When buying overtakes renting',
                cardWidth,
                null,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    String description,
    double width,
    Color? highlightColor, {
    Widget? trailingIcon,
  }) {
    return SizedBox(
      width: width,
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFEBEBEB)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ),
                  if (trailingIcon != null) trailingIcon,
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: highlightColor ?? const Color(0xFF212121),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
