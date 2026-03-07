import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/simulation_config.dart';
import '../models/simulation_result.dart';
import '../services/calculator.dart';
import '../services/stamp_duty_calculator.dart';
import '../providers/country_provider.dart';

import '../screens/tools/rent_vs_buy/rent_vs_buy_defaults.dart';

class SimulationConfigNotifier extends Notifier<SimulationConfig> {
  @override
  SimulationConfig build() {
    ref.listen(countryProvider, (previous, next) {
      if (previous?.code != next.code) {
        state = rentVsBuyDefaults[next.code] ?? rentVsBuyDefaults['us']!;
      }
    });
    final initialCountry = ref.read(countryProvider);
    return rentVsBuyDefaults[initialCountry.code] ?? rentVsBuyDefaults['us']!;
  }

  void updateConfig(SimulationConfig newConfig) {
    state = newConfig;
  }
}

final simulationConfigProvider =
    NotifierProvider<SimulationConfigNotifier, SimulationConfig>(() {
      return SimulationConfigNotifier();
    });

final simulationResultProvider = Provider<SimulationResult>((ref) {
  final config = ref.watch(simulationConfigProvider);
  final country = ref.watch(countryProvider);

  double totalOneTimeFees = config.oneTimeFees;

  if (country.hasStampDuty && country.stampDutyBands.isNotEmpty) {
    double stampDuty = calculateStampDuty(
      config.propertyPrice,
      country.stampDutyBands,
    );
    totalOneTimeFees += stampDuty;
  }

  final calculationConfig = config.copyWith(oneTimeFees: totalOneTimeFees);

  return calculateSimulation(calculationConfig);
});
