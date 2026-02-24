import 'dart:math';
import '../models/simulation_config.dart';
import '../models/simulation_result.dart';

SimulationResult calculateSimulation(SimulationConfig config) {
  final buyPoints = <NetWorthPoint>[];
  final rentPoints = <NetWorthPoint>[];
  final buyCashFlow = <double>[]; // +ve = inflow, -ve = outflow
  final rentCashFlow = <double>[];

  // Common parameters
  final double propertyGrowth = config.propertyGrowthRate / 100.0;
  final double investmentReturnRate = config.investmentReturn / 100.0;
  final double rentInflation = config.annualRentInflation / 100.0;
  final double buyingCosts =
      config.propertyPrice * (config.buyingCostsPercentage / 100.0);
  final double monthlyInterestRate = (config.interestRate / 100.0) / 12.0;
  final int totalMortgageMonths = config.mortgageTermYears * 12;

  // Initial Buy State — buying costs are added to one-time fees
  final double totalOneTimeFees = config.oneTimeFees + buyingCosts;
  final double loanAmount = config.propertyPrice - config.depositAmount;

  // Calculate fixed monthly mortgage payment
  double monthlyMortgage = 0.0;
  if (loanAmount > 0 && totalMortgageMonths > 0) {
    if (monthlyInterestRate > 0) {
      monthlyMortgage =
          loanAmount *
          monthlyInterestRate *
          pow(1 + monthlyInterestRate, totalMortgageMonths) /
          (pow(1 + monthlyInterestRate, totalMortgageMonths) - 1);
    } else {
      monthlyMortgage = loanAmount / totalMortgageMonths;
    }
  }

  // Cash on hand that the renter keeps invested
  double startingCash = config.depositAmount + totalOneTimeFees;

  double currentInvested = startingCash;
  double currentRent = config.monthlyRent;
  double currentPropertyPrice = config.propertyPrice;
  double remainingMortgage = loanAmount;
  int monthsElapsed = 0;

  for (int year = 0; year <= config.durationYears; year++) {
    if (year == 0) {
      // Year 0: initial outlay — both parties deploy the same capital
      buyCashFlow.add(-(config.depositAmount + totalOneTimeFees));
      rentCashFlow.add(-(config.depositAmount + totalOneTimeFees));

      buyPoints.add(
        NetWorthPoint(year: 0, amount: config.depositAmount - totalOneTimeFees),
      );
      rentPoints.add(NetWorthPoint(year: 0, amount: currentInvested));
      continue;
    }

    // Accumulate annual costs
    double yearlyServiceCharge = config.serviceChargeGroundRent;
    double monthlyOutgoings = yearlyServiceCharge / 12.0;
    double annualBuyCost = 0.0;
    double annualRentCost = 0.0;

    for (int month = 1; month <= 12; month++) {
      monthsElapsed++;

      // Buy process
      double actualMortgagePayment = 0;
      if (monthsElapsed <= totalMortgageMonths) {
        actualMortgagePayment = monthlyMortgage;
        double interestPayment = remainingMortgage * monthlyInterestRate;
        double principalPayment = monthlyMortgage - interestPayment;
        remainingMortgage -= principalPayment;
        if (remainingMortgage < 0) remainingMortgage = 0.0;
      }

      double buyCost = actualMortgagePayment + monthlyOutgoings;
      double savings = buyCost - currentRent;

      annualBuyCost += buyCost;
      annualRentCost += currentRent;

      // Compound investment (adding savings at end of month)
      currentInvested += currentInvested * (investmentReturnRate / 12.0);
      currentInvested += savings;
    }

    // End of year updates
    currentPropertyPrice *= (1 + propertyGrowth);
    currentRent *= (1 + rentInflation);

    final bool isFinalYear = year == config.durationYears;
    final double sellingCosts = isFinalYear
        ? currentPropertyPrice * (config.sellingCostsPercentage / 100.0)
        : 0.0;

    final double buyNetWorthThisYear =
        currentPropertyPrice - remainingMortgage - sellingCosts;
    final double rentNetWorthThisYear = currentInvested;

    // Cashflow: ongoing costs are negative outflows.
    // In the final year, net worth is returned as a lump-sum positive inflow.
    if (isFinalYear) {
      buyCashFlow.add(-annualBuyCost + buyNetWorthThisYear);
      rentCashFlow.add(-annualRentCost + rentNetWorthThisYear);
    } else {
      buyCashFlow.add(-annualBuyCost);
      rentCashFlow.add(-annualRentCost);
    }

    buyPoints.add(NetWorthPoint(year: year, amount: buyNetWorthThisYear));
    rentPoints.add(NetWorthPoint(year: year, amount: rentNetWorthThisYear));
  }

  final double finalDifference = buyPoints.last.amount - rentPoints.last.amount;
  int? breakevenYear;
  for (int i = 0; i <= config.durationYears; i++) {
    if (buyPoints[i].amount > rentPoints[i].amount) {
      breakevenYear = i;
      break;
    }
  }

  return SimulationResult(
    buyNetWorth: buyPoints,
    rentNetWorth: rentPoints,
    finalDifference: finalDifference,
    buyCashFlow: buyCashFlow,
    rentCashFlow: rentCashFlow,
    breakevenYear: breakevenYear,
  );
}
