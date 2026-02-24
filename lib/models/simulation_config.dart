import 'package:freezed_annotation/freezed_annotation.dart';

part 'simulation_config.freezed.dart';

@freezed
abstract class SimulationConfig with _$SimulationConfig {
  const factory SimulationConfig({
    @Default(300000.0) double propertyPrice,
    @Default(1500.0) double serviceChargeGroundRent,
    @Default(1200.0) double monthlyRent,
    @Default(30000.0) double depositAmount,
    @Default(10) int durationYears,
    @Default(4.5) double interestRate,
    @Default(25) int mortgageTermYears,
    @Default(2.0) double buyingCostsPercentage,
    @Default(2.0) double sellingCostsPercentage,
    @Default(2.0) double annualRentInflation,
    @Default(6.0) double investmentReturn,
    @Default(3.0) double propertyGrowthRate,
    @Default(2000.0) double oneTimeFees,
  }) = _SimulationConfig;
}
