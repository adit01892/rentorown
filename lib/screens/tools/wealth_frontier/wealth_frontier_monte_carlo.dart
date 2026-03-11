import 'dart:math';
import 'wealth_frontier_provider.dart';

class MonteCarloResult {
  final List<List<double>> p10Path;
  final List<List<double>> p50Path;
  final List<List<double>> p90Path;
  final double finalDebt;
  final double finalInvestments;
  final double finalNetWorth;

  MonteCarloResult({
    required this.p10Path,
    required this.p50Path,
    required this.p90Path,
    required this.finalDebt,
    required this.finalInvestments,
    required this.finalNetWorth,
  });
}

class MonteCarloParams {
  final WealthFrontierState state;
  final int iterations;

  MonteCarloParams({required this.state, this.iterations = 2000});
}

// Generate normally distributed random numbers
double _generateNormalRandom(Random rand) {
  double u = 1.0 - rand.nextDouble();
  double v = rand.nextDouble();
  return sqrt(-2.0 * log(u)) * cos(2.0 * pi * v);
}

Future<MonteCarloResult> runMonteCarloSimulation(
  WealthFrontierState state,
) async {
  return await Future.microtask(
    () => _calculateMonteCarlo(MonteCarloParams(state: state)),
  );
}

MonteCarloResult _calculateMonteCarlo(MonteCarloParams params) {
  final state = params.state;
  final iterations = params.iterations;

  final int totalMonths = state.durationYears * 12;
  final double monthlyDebtRate = (state.debtInterestRate / 100) / 12;

  // Convert annual return and vol to monthly
  final double annualReturn = state.expectedReturn / 100;
  final double annualVol = state.returnVolatility / 100;

  // Monthly expected return approx
  final double monthlyReturn = annualReturn / 12;
  final double monthlyVol = annualVol / sqrt(12);

  final Random rand = Random();

  // Store the net worth paths for all iterations
  // [iteration][month]
  List<List<double>> allPaths = List.generate(
    iterations,
    (_) => List.filled(totalMonths + 1, 0.0),
  );

  double sumFinalDebt = 0;
  double sumFinalInv = 0;

  for (int i = 0; i < iterations; i++) {
    double currentDebt = state.currentDebt;
    double currentInv = state.currentSavings;
    allPaths[i][0] = currentInv - currentDebt;

    for (int month = 1; month <= totalMonths; month++) {
      // 1. Grow debt
      currentDebt = currentDebt * (1 + monthlyDebtRate);

      // 2. Grow investments randomly
      double z = _generateNormalRandom(rand);
      double thisMonthReturn = monthlyReturn + z * monthlyVol;
      currentInv = currentInv * (1 + thisMonthReturn);

      // 3. Allocate extra cash
      double discretionaryCash = state.extraMonthlyCash;
      double mandatoryDebtPayment = 0;

      if (currentDebt > 0) {
        mandatoryDebtPayment = min(state.minimumDebtPayment, currentDebt);
      }

      discretionaryCash = max(0, discretionaryCash - mandatoryDebtPayment);

      double extraDebtPayment = 0;
      if (currentDebt > mandatoryDebtPayment) {
        extraDebtPayment = min(
          discretionaryCash * (state.debtAllocationPercentage / 100),
          currentDebt - mandatoryDebtPayment,
        );
      }

      double debtAllocation = mandatoryDebtPayment + extraDebtPayment;
      double invAllocation = discretionaryCash - extraDebtPayment;

      currentDebt = max(0, currentDebt - debtAllocation);
      currentInv += invAllocation;

      allPaths[i][month] = currentInv - currentDebt;
    }

    sumFinalDebt += currentDebt;
    sumFinalInv += currentInv;
  }

  // Calculate percentiles at each month
  List<List<double>> p10 = [];
  List<List<double>> p50 = [];
  List<List<double>> p90 = [];

  for (int month = 0; month <= totalMonths; month++) {
    // Collect all values for this month
    List<double> monthValues = List.generate(
      iterations,
      (i) => allPaths[i][month],
    );
    monthValues.sort();

    int idx10 = (iterations * 0.1).floor();
    int idx50 = (iterations * 0.5).floor();
    int idx90 = (iterations * 0.9).floor();

    double ageOrYear = month / 12; // x-axis in years

    p10.add([ageOrYear, monthValues[idx10]]);
    p50.add([ageOrYear, monthValues[idx50]]);
    p90.add([ageOrYear, monthValues[idx90]]);
  }

  return MonteCarloResult(
    p10Path: p10,
    p50Path: p50,
    p90Path: p90,
    finalDebt: sumFinalDebt / iterations,
    finalInvestments: sumFinalInv / iterations,
    finalNetWorth: p50.last[1], // User explicitly requests median on the UI
  );
}
