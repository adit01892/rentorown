import 'coast_fi_provider.dart';

final coastFiDefaults = {
  'uk': CoastFiState(
    currentAge: 30,
    retirementAge: 65,
    endAge: 90,
    pensionAccessAge: 57,
    currentSavings: 80000,
    monthlySavings: 500,
    annualSpendingRetirement: 40000,
    safeWithdrawalRate: 4.0,
    expectedAnnualReturn: 6.0,
    inflationRate: 3.0,
    incomeGrowthRate: 3.0,
    advancedMode: false,
    pension: _defaultAccount(
      startingBalance: 60000,
      monthlySaving: 1000,
      simpleReturn: 6.5,
    ),
    isa: _defaultAccount(
      startingBalance: 30000,
      monthlySaving: 1000,
      simpleReturn: 6.5,
    ),
    gia: _defaultAccount(
      startingBalance: 10000,
      monthlySaving: 500,
      simpleReturn: 6.5,
    ),
  ),
  'us': CoastFiState(
    currentAge: 30,
    retirementAge: 65,
    endAge: 90,
    pensionAccessAge: 59,
    currentSavings: 100000,
    monthlySavings: 600,
    annualSpendingRetirement: 60000,
    safeWithdrawalRate: 4.0,
    expectedAnnualReturn: 7.0,
    inflationRate: 3.0,
    incomeGrowthRate: 3.0,
    advancedMode: false,
    pension: _defaultAccount(
      startingBalance: 80000,
      monthlySaving: 1200,
      simpleReturn: 7.0,
    ),
    isa: _defaultAccount(
      startingBalance: 30000,
      monthlySaving: 800,
      simpleReturn: 7.0,
    ),
    gia: _defaultAccount(
      startingBalance: 20000,
      monthlySaving: 400,
      simpleReturn: 7.0,
    ),
  ),
  'eu': CoastFiState(
    currentAge: 30,
    retirementAge: 65,
    endAge: 90,
    pensionAccessAge: 60,
    currentSavings: 70000,
    monthlySavings: 400,
    annualSpendingRetirement: 35000,
    safeWithdrawalRate: 4.0,
    expectedAnnualReturn: 5.0,
    inflationRate: 2.5,
    incomeGrowthRate: 2.5,
    advancedMode: false,
    pension: _defaultAccount(
      startingBalance: 50000,
      monthlySaving: 800,
      simpleReturn: 5.5,
    ),
    isa: _defaultAccount(
      startingBalance: 25000,
      monthlySaving: 600,
      simpleReturn: 5.5,
    ),
    gia: _defaultAccount(
      startingBalance: 15000,
      monthlySaving: 300,
      simpleReturn: 5.5,
    ),
  ),
};

AccountState _defaultAccount({
  required double startingBalance,
  required double monthlySaving,
  required double simpleReturn,
}) {
  return AccountState(
    startingBalance: startingBalance,
    monthlySaving: monthlySaving,
    useCustomAllocation: false,
    simpleReturn: simpleReturn,
    allocations: {
      AssetKey.stocks: const AssetAllocation(
        enabled: true,
        allocationPercent: 85,
        expectedReturn: 8,
      ),
      AssetKey.bonds: const AssetAllocation(
        enabled: true,
        allocationPercent: 15,
        expectedReturn: 5,
      ),
      AssetKey.cash: const AssetAllocation(
        enabled: false,
        allocationPercent: 0,
        expectedReturn: 0.5,
      ),
      AssetKey.crypto: const AssetAllocation(
        enabled: false,
        allocationPercent: 0,
        expectedReturn: 2,
      ),
      AssetKey.other: const AssetAllocation(
        enabled: false,
        allocationPercent: 0,
        expectedReturn: 0,
      ),
    },
  );
}
