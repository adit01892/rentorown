import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/country_provider.dart';
import 'wealth_frontier_defaults.dart';

class WealthFrontierState {
  final double currentSavings;
  final double extraMonthlyCash;
  final double minimumDebtPayment;
  final double currentDebt;
  final double debtInterestRate;
  final double expectedReturn;
  final double returnVolatility;
  final int durationYears;
  final double debtAllocationPercentage;

  const WealthFrontierState({
    this.currentSavings = 50000,
    this.extraMonthlyCash = 2000,
    this.minimumDebtPayment = 500.0,
    this.currentDebt = 100000,
    this.debtInterestRate = 6.0,
    this.expectedReturn = 8.0,
    this.returnVolatility = 15.0,
    this.durationYears = 10,
    this.debtAllocationPercentage = 50.0,
  });

  WealthFrontierState copyWith({
    double? currentSavings,
    double? extraMonthlyCash,
    double? minimumDebtPayment,
    double? currentDebt,
    double? debtInterestRate,
    double? expectedReturn,
    double? returnVolatility,
    int? durationYears,
    double? debtAllocationPercentage,
  }) {
    return WealthFrontierState(
      currentSavings: currentSavings ?? this.currentSavings,
      extraMonthlyCash: extraMonthlyCash ?? this.extraMonthlyCash,
      minimumDebtPayment: minimumDebtPayment ?? this.minimumDebtPayment,
      currentDebt: currentDebt ?? this.currentDebt,
      debtInterestRate: debtInterestRate ?? this.debtInterestRate,
      expectedReturn: expectedReturn ?? this.expectedReturn,
      returnVolatility: returnVolatility ?? this.returnVolatility,
      durationYears: durationYears ?? this.durationYears,
      debtAllocationPercentage:
          debtAllocationPercentage ?? this.debtAllocationPercentage,
    );
  }
}

class WealthFrontierNotifier extends Notifier<WealthFrontierState> {
  @override
  WealthFrontierState build() {
    ref.listen(countryProvider, (previous, next) {
      if (previous?.code != next.code) {
        state =
            wealthFrontierDefaults[next.code] ?? wealthFrontierDefaults['us']!;
      }
    });
    final initialCountry = ref.read(countryProvider);
    return wealthFrontierDefaults[initialCountry.code] ??
        wealthFrontierDefaults['us']!;
  }

  void updateSavings(double value) =>
      state = state.copyWith(currentSavings: value);
  void updateMonthlyCash(double value) =>
      state = state.copyWith(extraMonthlyCash: value);
  void updateMinimumDebtPayment(double value) =>
      state = state.copyWith(minimumDebtPayment: value);
  void updateDebt(double value) => state = state.copyWith(currentDebt: value);
  void updateDebtRate(double value) =>
      state = state.copyWith(debtInterestRate: value);
  void updateExpectedReturn(double value) =>
      state = state.copyWith(expectedReturn: value);
  void updateVolatility(double value) =>
      state = state.copyWith(returnVolatility: value);
  void updateDuration(int value) =>
      state = state.copyWith(durationYears: value);
  void updateDebtAllocationPercentage(double value) =>
      state = state.copyWith(debtAllocationPercentage: value);
}

final wealthFrontierProvider =
    NotifierProvider<WealthFrontierNotifier, WealthFrontierState>(
      () => WealthFrontierNotifier(),
    );
