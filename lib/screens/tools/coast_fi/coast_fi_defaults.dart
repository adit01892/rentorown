import 'coast_fi_provider.dart';

final coastFiDefaults = {
  'uk': const CoastFiState(
    currentAge: 30,
    retirementAge: 65,
    currentSavings: 80000,
    annualSpendingRetirement: 40000,
    safeWithdrawalRate: 4.0,
    expectedAnnualReturn: 6.0,
    currentAnnualSavings: 10000,
  ),
  'us': const CoastFiState(
    currentAge: 30,
    retirementAge: 65,
    currentSavings: 100000,
    annualSpendingRetirement: 60000,
    safeWithdrawalRate: 4.0,
    expectedAnnualReturn: 7.0,
    currentAnnualSavings: 12000,
  ),
  'eu': const CoastFiState(
    currentAge: 30,
    retirementAge: 65,
    currentSavings: 70000,
    annualSpendingRetirement: 35000,
    safeWithdrawalRate: 4.0,
    expectedAnnualReturn: 5.0,
    currentAnnualSavings: 8000,
  ),
};
