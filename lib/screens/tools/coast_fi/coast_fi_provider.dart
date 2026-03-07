import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/country_provider.dart';
import 'coast_fi_defaults.dart';

class CoastFiState {
  final int currentAge;
  final int retirementAge;
  final double currentSavings;
  final double annualSpendingRetirement;
  final double safeWithdrawalRate; // e.g. 4.0 for 4%
  final double expectedAnnualReturn; // e.g. 7.0 for 7%
  final double currentAnnualSavings;

  const CoastFiState({
    this.currentAge = 30,
    this.retirementAge = 65,
    this.currentSavings = 100000,
    this.annualSpendingRetirement = 60000,
    this.safeWithdrawalRate = 4.0,
    this.expectedAnnualReturn = 7.0,
    this.currentAnnualSavings = 12000,
  });

  CoastFiState copyWith({
    int? currentAge,
    int? retirementAge,
    double? currentSavings,
    double? annualSpendingRetirement,
    double? safeWithdrawalRate,
    double? expectedAnnualReturn,
    double? currentAnnualSavings,
  }) {
    return CoastFiState(
      currentAge: currentAge ?? this.currentAge,
      retirementAge: retirementAge ?? this.retirementAge,
      currentSavings: currentSavings ?? this.currentSavings,
      annualSpendingRetirement:
          annualSpendingRetirement ?? this.annualSpendingRetirement,
      safeWithdrawalRate: safeWithdrawalRate ?? this.safeWithdrawalRate,
      expectedAnnualReturn: expectedAnnualReturn ?? this.expectedAnnualReturn,
      currentAnnualSavings: currentAnnualSavings ?? this.currentAnnualSavings,
    );
  }

  // Mathematics for Coast FI

  /// Total amount needed at retirement age to safely withdraw desired annual spending
  double get requiredRetirementCorpus {
    if (safeWithdrawalRate <= 0) return 0;
    return annualSpendingRetirement / (safeWithdrawalRate / 100);
  }

  /// The amount you would need TODAY so that it grows to the requiredRetirementCorpus by retirement age without adding another dime.
  double get coastNumberToday {
    final yearsToRetirement = retirementAge - currentAge;
    if (yearsToRetirement <= 0) return requiredRetirementCorpus;

    // PV = FV / (1 + r)^n
    return requiredRetirementCorpus /
        pow(1 + (expectedAnnualReturn / 100), yearsToRetirement);
  }

  bool get isCoasting => currentSavings >= coastNumberToday;

  /// Future value of existing current savings at retirement
  double get coastingFutureValue {
    final yearsToRetirement = retirementAge - currentAge;
    if (yearsToRetirement <= 0) return currentSavings;
    return currentSavings *
        pow(1 + (expectedAnnualReturn / 100), yearsToRetirement);
  }
}

class CoastFiNotifier extends Notifier<CoastFiState> {
  @override
  CoastFiState build() {
    ref.listen(countryProvider, (previous, next) {
      if (previous?.code != next.code) {
        state = coastFiDefaults[next.code] ?? coastFiDefaults['us']!;
      }
    });
    final initialCountry = ref.read(countryProvider);
    return coastFiDefaults[initialCountry.code] ?? coastFiDefaults['us']!;
  }

  void updateCurrentAge(int value) {
    if (value < state.retirementAge) {
      state = state.copyWith(currentAge: value);
    }
  }

  void updateRetirementAge(int value) {
    if (value > state.currentAge) {
      state = state.copyWith(retirementAge: value);
    }
  }

  void updateCurrentSavings(double value) =>
      state = state.copyWith(currentSavings: value);
  void updateAnnualSpendingRetirement(double value) =>
      state = state.copyWith(annualSpendingRetirement: value);
  void updateSafeWithdrawalRate(double value) =>
      state = state.copyWith(safeWithdrawalRate: value);
  void updateExpectedReturn(double value) =>
      state = state.copyWith(expectedAnnualReturn: value);
  void updateCurrentAnnualSavings(double value) =>
      state = state.copyWith(currentAnnualSavings: value);
}

final coastFiProvider = NotifierProvider<CoastFiNotifier, CoastFiState>(
  () => CoastFiNotifier(),
);
