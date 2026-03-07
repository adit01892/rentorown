import '../../../models/simulation_config.dart';

final rentVsBuyDefaults = {
  'uk': const SimulationConfig(
    propertyPrice: 400000,
    depositAmount: 80000,
    interestRate: 4.5,
    mortgageTermYears: 25,
    monthlyRent: 1500,
    annualRentInflation: 2.0,
    propertyGrowthRate: 3.0,
    investmentReturn: 6.0,
  ),
  'us': const SimulationConfig(
    propertyPrice: 500000,
    depositAmount: 100000,
    interestRate: 6.5,
    mortgageTermYears: 30,
    monthlyRent: 2500,
    annualRentInflation: 3.0,
    propertyGrowthRate: 4.0,
    investmentReturn: 7.0,
  ),
  'eu': const SimulationConfig(
    propertyPrice: 350000,
    depositAmount: 70000,
    interestRate: 3.5,
    mortgageTermYears: 20,
    monthlyRent: 1200,
    annualRentInflation: 2.5,
    propertyGrowthRate: 2.5,
    investmentReturn: 5.0,
  ),
};
