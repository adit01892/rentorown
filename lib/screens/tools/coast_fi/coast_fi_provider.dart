import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/country_provider.dart';
import 'coast_fi_defaults.dart';

enum AssetKey { stocks, bonds, cash, crypto, other }

class AssetAllocation {
  final bool enabled;
  final double allocationPercent; // 0-100
  final double expectedReturn; // %

  const AssetAllocation({
    required this.enabled,
    required this.allocationPercent,
    required this.expectedReturn,
  });

  AssetAllocation copyWith({
    bool? enabled,
    double? allocationPercent,
    double? expectedReturn,
  }) {
    return AssetAllocation(
      enabled: enabled ?? this.enabled,
      allocationPercent: allocationPercent ?? this.allocationPercent,
      expectedReturn: expectedReturn ?? this.expectedReturn,
    );
  }
}

class AccountState {
  final double startingBalance;
  final double monthlySaving;
  final bool useCustomAllocation;
  final double simpleReturn; // % when not using custom allocation
  final Map<AssetKey, AssetAllocation> allocations;

  const AccountState({
    required this.startingBalance,
    required this.monthlySaving,
    required this.useCustomAllocation,
    required this.simpleReturn,
    required this.allocations,
  });

  AccountState copyWith({
    double? startingBalance,
    double? monthlySaving,
    bool? useCustomAllocation,
    double? simpleReturn,
    Map<AssetKey, AssetAllocation>? allocations,
  }) {
    return AccountState(
      startingBalance: startingBalance ?? this.startingBalance,
      monthlySaving: monthlySaving ?? this.monthlySaving,
      useCustomAllocation: useCustomAllocation ?? this.useCustomAllocation,
      simpleReturn: simpleReturn ?? this.simpleReturn,
      allocations: allocations ?? this.allocations,
    );
  }

  double allocationTotal() {
    double total = 0;
    allocations.forEach((key, value) {
      if (value.enabled) total += value.allocationPercent;
    });
    return total;
  }

  double expectedReturnRate() {
    if (!useCustomAllocation) return simpleReturn;
    double weighted = 0;
    allocations.forEach((key, value) {
      if (value.enabled) {
        weighted += value.allocationPercent * value.expectedReturn;
      }
    });
    // If total allocation is not 100, scale by 100 for a conservative estimate.
    return weighted / 100;
  }
}

class ProjectionYear {
  final int age;
  final double pension;
  final double isa;
  final double gia;
  final double total;
  final double savings;
  final double spending;
  final double fireNumber;

  const ProjectionYear({
    required this.age,
    required this.pension,
    required this.isa,
    required this.gia,
    required this.total,
    required this.savings,
    required this.spending,
    required this.fireNumber,
  });
}

class CoastFiState {
  final int currentAge;
  final int retirementAge;
  final int endAge;
  final int pensionAccessAge;
  final double currentSavings;
  final double monthlySavings;
  final double annualSpendingRetirement;
  final double safeWithdrawalRate; // e.g. 4.0 for 4%
  final double expectedAnnualReturn; // % (real return in simple mode)
  final double inflationRate; // %
  final double incomeGrowthRate; // %
  final bool advancedMode;
  final AccountState pension;
  final AccountState isa;
  final AccountState gia;

  const CoastFiState({
    this.currentAge = 30,
    this.retirementAge = 65,
    this.endAge = 90,
    this.pensionAccessAge = 57,
    this.currentSavings = 100000,
    this.monthlySavings = 0,
    this.annualSpendingRetirement = 60000,
    this.safeWithdrawalRate = 4.0,
    this.expectedAnnualReturn = 7.0,
    this.inflationRate = 3.0,
    this.incomeGrowthRate = 3.0,
    this.advancedMode = false,
    required this.pension,
    required this.isa,
    required this.gia,
  });

  CoastFiState copyWith({
    int? currentAge,
    int? retirementAge,
    int? endAge,
    int? pensionAccessAge,
    double? currentSavings,
    double? monthlySavings,
    double? annualSpendingRetirement,
    double? safeWithdrawalRate,
    double? expectedAnnualReturn,
    double? inflationRate,
    double? incomeGrowthRate,
    bool? advancedMode,
    AccountState? pension,
    AccountState? isa,
    AccountState? gia,
  }) {
    return CoastFiState(
      currentAge: currentAge ?? this.currentAge,
      retirementAge: retirementAge ?? this.retirementAge,
      endAge: endAge ?? this.endAge,
      pensionAccessAge: pensionAccessAge ?? this.pensionAccessAge,
      currentSavings: currentSavings ?? this.currentSavings,
      monthlySavings: monthlySavings ?? this.monthlySavings,
      annualSpendingRetirement:
          annualSpendingRetirement ?? this.annualSpendingRetirement,
      safeWithdrawalRate: safeWithdrawalRate ?? this.safeWithdrawalRate,
      expectedAnnualReturn: expectedAnnualReturn ?? this.expectedAnnualReturn,
      inflationRate: inflationRate ?? this.inflationRate,
      incomeGrowthRate: incomeGrowthRate ?? this.incomeGrowthRate,
      advancedMode: advancedMode ?? this.advancedMode,
      pension: pension ?? this.pension,
      isa: isa ?? this.isa,
      gia: gia ?? this.gia,
    );
  }

  double get requiredRetirementCorpus {
    if (safeWithdrawalRate <= 0) return 0;
    return annualSpendingRetirement / (safeWithdrawalRate / 100);
  }

  double get coastNumberToday {
    final yearsToRetirement = retirementAge - currentAge;
    if (yearsToRetirement <= 0) return requiredRetirementCorpus;

    return requiredRetirementCorpus /
        pow(1 + (expectedAnnualReturn / 100), yearsToRetirement);
  }

  bool get isCoasting => currentSavings >= coastNumberToday;

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
        state = coastFiDefaults[next.code] ?? coastFiDefaults['uk']!;
      }
    });
    final initialCountry = ref.read(countryProvider);
    return coastFiDefaults[initialCountry.code] ?? coastFiDefaults['uk']!;
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

  void updateEndAge(int value) {
    if (value >= state.retirementAge) {
      state = state.copyWith(endAge: value);
    }
  }

  void updatePensionAccessAge(int value) {
    if (value >= state.currentAge && value <= state.endAge) {
      state = state.copyWith(pensionAccessAge: value);
    }
  }

  void updateCurrentSavings(double value) =>
      state = state.copyWith(currentSavings: value);
  void updateMonthlySavings(double value) =>
      state = state.copyWith(monthlySavings: value);
  void updateAnnualSpendingRetirement(double value) =>
      state = state.copyWith(annualSpendingRetirement: value);
  void updateSafeWithdrawalRate(double value) =>
      state = state.copyWith(safeWithdrawalRate: value);
  void updateExpectedReturn(double value) =>
      state = state.copyWith(expectedAnnualReturn: value);
  void updateInflationRate(double value) =>
      state = state.copyWith(inflationRate: value);
  void updateIncomeGrowthRate(double value) =>
      state = state.copyWith(incomeGrowthRate: value);
  void updateAdvancedMode(bool value) =>
      state = state.copyWith(advancedMode: value);

  void updateAccountBalance(String account, double value) {
    if (account == 'pension') {
      state = state.copyWith(
        pension: state.pension.copyWith(startingBalance: value),
      );
    } else if (account == 'isa') {
      state = state.copyWith(isa: state.isa.copyWith(startingBalance: value));
    } else if (account == 'gia') {
      state = state.copyWith(gia: state.gia.copyWith(startingBalance: value));
    }
  }

  void updateAccountMonthlySaving(String account, double value) {
    if (account == 'pension') {
      state = state.copyWith(
        pension: state.pension.copyWith(monthlySaving: value),
      );
    } else if (account == 'isa') {
      state = state.copyWith(isa: state.isa.copyWith(monthlySaving: value));
    } else if (account == 'gia') {
      state = state.copyWith(gia: state.gia.copyWith(monthlySaving: value));
    }
  }

  void updateAccountUseCustom(String account, bool value) {
    if (account == 'pension') {
      state = state.copyWith(
        pension: state.pension.copyWith(useCustomAllocation: value),
      );
    } else if (account == 'isa') {
      state = state.copyWith(
        isa: state.isa.copyWith(useCustomAllocation: value),
      );
    } else if (account == 'gia') {
      state = state.copyWith(
        gia: state.gia.copyWith(useCustomAllocation: value),
      );
    }
  }

  void updateAccountSimpleReturn(String account, double value) {
    if (account == 'pension') {
      state = state.copyWith(
        pension: state.pension.copyWith(simpleReturn: value),
      );
    } else if (account == 'isa') {
      state = state.copyWith(isa: state.isa.copyWith(simpleReturn: value));
    } else if (account == 'gia') {
      state = state.copyWith(gia: state.gia.copyWith(simpleReturn: value));
    }
  }

  void updateAccountAsset(
    String account,
    AssetKey asset, {
    bool? enabled,
    double? allocationPercent,
    double? expectedReturn,
  }) {
    AccountState target;
    if (account == 'pension') {
      target = state.pension;
    } else if (account == 'isa') {
      target = state.isa;
    } else {
      target = state.gia;
    }

    final current = target.allocations[asset]!;
    final updated = current.copyWith(
      enabled: enabled,
      allocationPercent: allocationPercent,
      expectedReturn: expectedReturn,
    );
    final updatedMap = Map<AssetKey, AssetAllocation>.from(target.allocations)
      ..[asset] = updated;

    final updatedAccount = target.copyWith(allocations: updatedMap);
    if (account == 'pension') {
      state = state.copyWith(pension: updatedAccount);
    } else if (account == 'isa') {
      state = state.copyWith(isa: updatedAccount);
    } else {
      state = state.copyWith(gia: updatedAccount);
    }
  }

  List<ProjectionYear> computeProjection({required bool advanced}) {
    final List<ProjectionYear> projection = [];

    final years = max(0, state.endAge - state.currentAge);
    double pension = advanced ? state.pension.startingBalance : 0;
    double isa = advanced ? state.isa.startingBalance : 0;
    double gia = advanced ? state.gia.startingBalance : 0;
    double totalSimple = advanced ? 0 : state.currentSavings;

    for (int i = 0; i <= years; i++) {
      final age = state.currentAge + i;
      final spending = state.annualSpendingRetirement *
          pow(1 + (state.inflationRate / 100), i);
      final fireNumber = spending / (state.safeWithdrawalRate / 100);

      double savingsThisYear = 0;
      if (age < state.retirementAge) {
        final incomeGrowth = pow(1 + (state.incomeGrowthRate / 100), i);
        if (advanced) {
          final pensionSave = state.pension.monthlySaving * 12 * incomeGrowth;
          final isaSave = state.isa.monthlySaving * 12 * incomeGrowth;
          final giaSave = state.gia.monthlySaving * 12 * incomeGrowth;
          pension += pensionSave;
          isa += isaSave;
          gia += giaSave;
          savingsThisYear = pensionSave + isaSave + giaSave;
        } else {
          final save = state.monthlySavings * 12 * incomeGrowth;
          totalSimple += save;
          savingsThisYear = save;
        }
      }

      if (advanced) {
        pension *= 1 + (state.pension.expectedReturnRate() / 100);
        isa *= 1 + (state.isa.expectedReturnRate() / 100);
        gia *= 1 + (state.gia.expectedReturnRate() / 100);
      } else {
        totalSimple *= 1 + (state.expectedAnnualReturn / 100);
      }

      if (age >= state.retirementAge) {
        double remainingSpend = spending;

        if (advanced) {
          if (gia > 0 && remainingSpend > 0) {
            final take = min(gia, remainingSpend);
            gia -= take;
            remainingSpend -= take;
          }
          if (isa > 0 && remainingSpend > 0) {
            final take = min(isa, remainingSpend);
            isa -= take;
            remainingSpend -= take;
          }
          if (age >= state.pensionAccessAge && pension > 0 && remainingSpend > 0) {
            final take = min(pension, remainingSpend);
            pension -= take;
            remainingSpend -= take;
          }
        } else {
          if (totalSimple > 0 && remainingSpend > 0) {
            final take = min(totalSimple, remainingSpend);
            totalSimple -= take;
            remainingSpend -= take;
          }
        }
      }

      final total = advanced ? (pension + isa + gia) : totalSimple;
      projection.add(
        ProjectionYear(
          age: age,
          pension: pension,
          isa: isa,
          gia: gia,
          total: total,
          savings: savingsThisYear,
          spending: age >= state.retirementAge ? spending : 0,
          fireNumber: fireNumber,
        ),
      );
    }

    return projection;
  }
}

final coastFiProvider = NotifierProvider<CoastFiNotifier, CoastFiState>(
  () => CoastFiNotifier(),
);
