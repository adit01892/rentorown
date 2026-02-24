import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/country_provider.dart';
import '../providers/simulation_provider.dart';
import '../utils/constants.dart';

class CountrySelectorWidget extends ConsumerWidget {
  const CountrySelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCountry = ref.watch(countryProvider);

    return DropdownButton<String>(
      value: currentCountry.code,
      underline: const SizedBox(),
      icon: const Icon(Icons.arrow_drop_down),
      items: availableCountries.entries.map((entry) {
        return DropdownMenuItem(
          value: entry.key,
          child: Row(
            children: [
              Text(_getFlagEmoji(entry.key)),
              const SizedBox(width: 8),
              Text(entry.key.toUpperCase()),
            ],
          ),
        );
      }).toList(),
      onChanged: (val) {
        if (val != null) {
          final countryConfig = availableCountries[val];
          if (countryConfig == null) {
            return;
          }

          ref.read(countryProvider.notifier).setCountry(val);

          final currentConfig = ref.read(simulationConfigProvider);
          ref
              .read(simulationConfigProvider.notifier)
              .updateConfig(
                currentConfig.copyWith(
                  interestRate: countryConfig.defaultInterestRate,
                  mortgageTermYears: countryConfig.defaultMortgageTerm,
                  annualRentInflation: countryConfig.defaultRentInflation,
                  investmentReturn: countryConfig.defaultInvestmentReturn,
                  propertyGrowthRate: countryConfig.defaultPropertyGrowth,
                ),
              );
        }
      },
    );
  }

  String _getFlagEmoji(String code) {
    switch (code) {
      case 'uk':
        return '🇬🇧';
      case 'us':
        return '🇺🇸';
      case 'eu':
        return '🇪🇺';
      default:
        return '🌍';
    }
  }
}
