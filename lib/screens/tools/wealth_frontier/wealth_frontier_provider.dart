import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/country_provider.dart';
import 'wealth_frontier_defaults.dart';

enum WealthStrategy { payDebtFirst, investFirst, split5050 }

class WealthFrontierState {
  final double currentSavings;
  final double extraMonthlyCash;
  final double currentDebt;
  final double debtInterestRate;
  final double expectedReturn;
  final double returnVolatility;
  final int durationYears;
  final WealthStrategy strategy;

  const WealthFrontierState({
    this.currentSavings = 50000,
    this.extraMonthlyCash = 2000,
    this.currentDebt = 100000,
    this.debtInterestRate = 6.0,
    this.expectedReturn = 8.0,
    this.returnVolatility = 15.0,
    this.durationYears = 10,
    this.strategy = WealthStrategy.split5050,
  });

  WealthFrontierState copyWith({
    double? currentSavings,
    double? extraMonthlyCash,
    double? currentDebt,
    double? debtInterestRate,
    double? expectedReturn,
    double? returnVolatility,
    int? durationYears,
    WealthStrategy? strategy,
  }) {
    return WealthFrontierState(
      currentSavings: currentSavings ?? this.currentSavings,
      extraMonthlyCash: extraMonthlyCash ?? this.extraMonthlyCash,
      currentDebt: currentDebt ?? this.currentDebt,
      debtInterestRate: debtInterestRate ?? this.debtInterestRate,
      expectedReturn: expectedReturn ?? this.expectedReturn,
      returnVolatility: returnVolatility ?? this.returnVolatility,
      durationYears: durationYears ?? this.durationYears,
      strategy: strategy ?? this.strategy,
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
  void updateDebt(double value) => state = state.copyWith(currentDebt: value);
  void updateDebtRate(double value) =>
      state = state.copyWith(debtInterestRate: value);
  void updateExpectedReturn(double value) =>
      state = state.copyWith(expectedReturn: value);
  void updateVolatility(double value) =>
      state = state.copyWith(returnVolatility: value);
  void updateDuration(int value) =>
      state = state.copyWith(durationYears: value);
  void updateStrategy(WealthStrategy value) =>
      state = state.copyWith(strategy: value);
}

final wealthFrontierProvider =
    NotifierProvider<WealthFrontierNotifier, WealthFrontierState>(
      () => WealthFrontierNotifier(),
    );
