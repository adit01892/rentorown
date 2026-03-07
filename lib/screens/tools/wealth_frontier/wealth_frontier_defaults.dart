import 'wealth_frontier_provider.dart';

final wealthFrontierDefaults = {
  'us': const WealthFrontierState(
    currentSavings: 50000,
    extraMonthlyCash: 2000,
    currentDebt: 80000,
    debtInterestRate: 6.5,
    expectedReturn: 8.0,
    returnVolatility: 15.0,
    durationYears: 10,
    strategy: WealthStrategy.split5050,
  ),
  'uk': const WealthFrontierState(
    currentSavings: 30000,
    extraMonthlyCash: 1200,
    currentDebt: 50000,
    debtInterestRate: 5.5,
    expectedReturn: 7.0,
    returnVolatility: 15.0,
    durationYears: 10,
    strategy: WealthStrategy.split5050,
  ),
  'eu': const WealthFrontierState(
    currentSavings: 40000,
    extraMonthlyCash: 1500,
    currentDebt: 60000,
    debtInterestRate: 4.5,
    expectedReturn: 6.0,
    returnVolatility: 12.0,
    durationYears: 10,
    strategy: WealthStrategy.split5050,
  ),
};
