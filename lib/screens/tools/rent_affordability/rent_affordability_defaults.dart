import 'rent_affordability_provider.dart';

final rentAffordabilityDefaults = {
  'uk': const RentAffordabilityState(
    grossMonthlyIncome: 4500,
    netMonthlyIncome: 3500,
    fixedExpenses: 600,
    savingsGoals: 400,
    discretionarySpending: 500,
  ),
  'us': const RentAffordabilityState(
    grossMonthlyIncome: 6000,
    netMonthlyIncome: 4500,
    fixedExpenses: 800,
    savingsGoals: 600,
    discretionarySpending: 600,
  ),
  'eu': const RentAffordabilityState(
    grossMonthlyIncome: 4000,
    netMonthlyIncome: 3000,
    fixedExpenses: 500,
    savingsGoals: 300,
    discretionarySpending: 400,
  ),
};
