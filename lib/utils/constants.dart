import '../models/country_config.dart';

const ukConfig = CountryConfig(
  code: 'uk',
  currencySymbol: '£',
  currencyCode: 'GBP',
  defaultInterestRate: 4.5,
  defaultMortgageTerm: 25,
  defaultRentInflation: 2.0,
  defaultInvestmentReturn: 6.0,
  defaultPropertyGrowth: 3.0,
  hasStampDuty: true,
  stampDutyBands: {0: 0.0, 250000: 0.05, 925000: 0.10, 1500000: 0.12},
);

const usConfig = CountryConfig(
  code: 'us',
  currencySymbol: '\$',
  currencyCode: 'USD',
  defaultInterestRate: 6.5,
  defaultMortgageTerm: 30,
  defaultRentInflation: 3.0,
  defaultInvestmentReturn: 7.0,
  defaultPropertyGrowth: 4.0,
  hasStampDuty: false,
  stampDutyBands: <int, double>{},
);

const euConfig = CountryConfig(
  code: 'eu',
  currencySymbol: '€',
  currencyCode: 'EUR',
  defaultInterestRate: 3.5,
  defaultMortgageTerm: 20,
  defaultRentInflation: 2.5,
  defaultInvestmentReturn: 5.0,
  defaultPropertyGrowth: 2.5,
  hasStampDuty: false,
  stampDutyBands: <int, double>{},
);

final availableCountries = {'uk': ukConfig, 'us': usConfig, 'eu': euConfig};
