import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/country_provider.dart';
import 'rent_affordability_defaults.dart';

class RentAffordabilityState {
  final double grossMonthlyIncome;
  final double netMonthlyIncome;
  final double fixedExpenses;
  final double savingsGoals;
  final double discretionarySpending;

  const RentAffordabilityState({
    this.grossMonthlyIncome = 5000,
    this.netMonthlyIncome = 4000,
    this.fixedExpenses = 500,
    this.savingsGoals = 500,
    this.discretionarySpending = 500,
  });

  RentAffordabilityState copyWith({
    double? grossMonthlyIncome,
    double? netMonthlyIncome,
    double? fixedExpenses,
    double? savingsGoals,
    double? discretionarySpending,
  }) {
    return RentAffordabilityState(
      grossMonthlyIncome: grossMonthlyIncome ?? this.grossMonthlyIncome,
      netMonthlyIncome: netMonthlyIncome ?? this.netMonthlyIncome,
      fixedExpenses: fixedExpenses ?? this.fixedExpenses,
      savingsGoals: savingsGoals ?? this.savingsGoals,
      discretionarySpending:
          discretionarySpending ?? this.discretionarySpending,
    );
  }

  // Derived properties
  double get maxAffordableRent =>
      netMonthlyIncome - fixedExpenses - savingsGoals;
  double get recommendedRent => maxAffordableRent - discretionarySpending;
  double get rule30PercentGross => grossMonthlyIncome * 0.30;

  double get remainingBuffer =>
      netMonthlyIncome -
      fixedExpenses -
      savingsGoals -
      discretionarySpending -
      recommendedRent; // Which is usually 0 if we allocate all
}

class RentAffordabilityNotifier extends Notifier<RentAffordabilityState> {
  @override
  RentAffordabilityState build() {
    ref.listen(countryProvider, (previous, next) {
      if (previous?.code != next.code) {
        state =
            rentAffordabilityDefaults[next.code] ??
            rentAffordabilityDefaults['us']!;
      }
    });
    final initialCountry = ref.read(countryProvider);
    return rentAffordabilityDefaults[initialCountry.code] ??
        rentAffordabilityDefaults['us']!;
  }

  void updateGrossIncome(double value) {
    state = state.copyWith(grossMonthlyIncome: value);
  }

  void updateNetIncome(double value) {
    state = state.copyWith(netMonthlyIncome: value);
  }

  void updateFixedExpenses(double value) {
    state = state.copyWith(fixedExpenses: value);
  }

  void updateSavingsGoals(double value) {
    state = state.copyWith(savingsGoals: value);
  }

  void updateDiscretionarySpending(double value) {
    state = state.copyWith(discretionarySpending: value);
  }
}

final rentAffordabilityProvider =
    NotifierProvider<RentAffordabilityNotifier, RentAffordabilityState>(
      () => RentAffordabilityNotifier(),
    );
