import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_config.freezed.dart';

@freezed
abstract class CountryConfig with _$CountryConfig {
  const factory CountryConfig({
    required String code,
    required String currencySymbol,
    required String currencyCode,
    @Default(4.5) double defaultInterestRate,
    @Default(25) int defaultMortgageTerm,
    @Default(2.0) double defaultRentInflation,
    @Default(6.0) double defaultInvestmentReturn,
    @Default(3.0) double defaultPropertyGrowth,
    @Default(false) bool hasStampDuty,
    @Default({}) Map<int, double> stampDutyBands,
  }) = _CountryConfig;
}
