import 'espp_rsu_provider.dart';

final esppRsuDefaults = {
  'us': const EsppRsuData(
    espp: EsppState(
      offeringPeriodMonths: 6,
      startPrice: 100,
      endPrice: 120,
      discountPercentage: 15,
      hasLookback: true,
      contributionPercentage: 10,
      grossIncome: 120000,
    ),
    rsu: RsuState(
      totalGrantValue: 100000,
      durationYears: 4,
      cliffMonths: 12,
      vestingFrequencyMonths: 3,
      estimatedTaxRate: 35,
      expectedStockGrowth: 5,
    ),
  ),
  'uk': const EsppRsuData(
    espp: EsppState(
      offeringPeriodMonths: 6,
      startPrice: 100,
      endPrice: 120,
      discountPercentage: 15,
      hasLookback: true,
      contributionPercentage: 10,
      grossIncome: 80000,
    ),
    rsu: RsuState(
      totalGrantValue: 80000,
      durationYears: 4,
      cliffMonths: 12,
      vestingFrequencyMonths: 3,
      estimatedTaxRate: 45, // Higher tax rate commonly seen
      expectedStockGrowth: 5,
    ),
  ),
  'eu': const EsppRsuData(
    espp: EsppState(
      offeringPeriodMonths: 6,
      startPrice: 100,
      endPrice: 120,
      discountPercentage: 15,
      hasLookback: true,
      contributionPercentage: 10,
      grossIncome: 70000,
    ),
    rsu: RsuState(
      totalGrantValue: 70000,
      durationYears: 4,
      cliffMonths: 12,
      vestingFrequencyMonths: 3,
      estimatedTaxRate: 40,
      expectedStockGrowth: 5,
    ),
  ),
};
