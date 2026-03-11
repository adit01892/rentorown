import 'wealth_frontier_provider.dart';

final wealthFrontierDefaults = {
  'us': const WealthFrontierState(
    currentSavings: 50000,
    extraMonthlyCash: 2000,
    minimumDebtPayment: 500,
    currentDebt: 80000,
    debtInterestRate: 6.5,
    expectedReturn: 8.0,
    returnVolatility: 15.0,
    durationYears: 10,
    debtAllocationPercentage: 50.0,
  ),
  'uk': const WealthFrontierState(
    currentSavings: 30000,
    extraMonthlyCash: 1200,
    minimumDebtPayment: 400,
    currentDebt: 50000,
    debtInterestRate: 5.5,
    expectedReturn: 7.0,
    returnVolatility: 15.0,
    durationYears: 10,
    debtAllocationPercentage: 50.0,
  ),
  'eu': const WealthFrontierState(
    currentSavings: 40000,
    extraMonthlyCash: 1500,
    minimumDebtPayment: 350,
    currentDebt: 60000,
    debtInterestRate: 4.5,
    expectedReturn: 6.0,
    returnVolatility: 12.0,
    durationYears: 10,
    debtAllocationPercentage: 50.0,
  ),
};
