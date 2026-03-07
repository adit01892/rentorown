import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/country_provider.dart';
import 'espp_rsu_defaults.dart';

class EsppState {
  final double offeringPeriodMonths;
  final double startPrice;
  final double endPrice;
  final double discountPercentage;
  final bool hasLookback;
  final double contributionPercentage;
  final double grossIncome;

  const EsppState({
    this.offeringPeriodMonths = 6,
    this.startPrice = 100,
    this.endPrice = 120,
    this.discountPercentage = 15,
    this.hasLookback = true,
    this.contributionPercentage = 10,
    this.grossIncome = 120000,
  });

  EsppState copyWith({
    double? offeringPeriodMonths,
    double? startPrice,
    double? endPrice,
    double? discountPercentage,
    bool? hasLookback,
    double? contributionPercentage,
    double? grossIncome,
  }) {
    return EsppState(
      offeringPeriodMonths: offeringPeriodMonths ?? this.offeringPeriodMonths,
      startPrice: startPrice ?? this.startPrice,
      endPrice: endPrice ?? this.endPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      hasLookback: hasLookback ?? this.hasLookback,
      contributionPercentage:
          contributionPercentage ?? this.contributionPercentage,
      grossIncome: grossIncome ?? this.grossIncome,
    );
  }

  double get cashInvested =>
      grossIncome *
      (contributionPercentage / 100) *
      (offeringPeriodMonths / 12);

  double get purchasePrice {
    final basePrice = hasLookback
        ? (startPrice < endPrice ? startPrice : endPrice)
        : endPrice;
    return basePrice * (1 - (discountPercentage / 100));
  }

  double get sharesBought => cashInvested / purchasePrice;
  double get valueAtEnd => sharesBought * endPrice;
  double get profit => valueAtEnd - cashInvested;

  // Annualized return = (Profit / Average Cash Invested) * (12 / Duration)
  // Usually cash is invested evenly over the 6 months, so average cash invested is ~ half the total cash.
  // Standard simple formula: (Profit / Cash Invested) * (12 / Duration)
  double get effectiveYield => cashInvested > 0
      ? (profit / cashInvested) * (12 / offeringPeriodMonths)
      : 0.0;
}

class RsuState {
  final double totalGrantValue;
  final double durationYears;
  final double cliffMonths;
  final double vestingFrequencyMonths; // e.g. 3 for quarterly
  final double estimatedTaxRate;
  final double expectedStockGrowth; // Annualized

  const RsuState({
    this.totalGrantValue = 100000,
    this.durationYears = 4,
    this.cliffMonths = 12,
    this.vestingFrequencyMonths = 3,
    this.estimatedTaxRate = 35,
    this.expectedStockGrowth = 5,
  });

  RsuState copyWith({
    double? totalGrantValue,
    double? durationYears,
    double? cliffMonths,
    double? vestingFrequencyMonths,
    double? estimatedTaxRate,
    double? expectedStockGrowth,
  }) {
    return RsuState(
      totalGrantValue: totalGrantValue ?? this.totalGrantValue,
      durationYears: durationYears ?? this.durationYears,
      cliffMonths: cliffMonths ?? this.cliffMonths,
      vestingFrequencyMonths:
          vestingFrequencyMonths ?? this.vestingFrequencyMonths,
      estimatedTaxRate: estimatedTaxRate ?? this.estimatedTaxRate,
      expectedStockGrowth: expectedStockGrowth ?? this.expectedStockGrowth,
    );
  }
}

class EsppRsuData {
  final EsppState espp;
  final RsuState rsu;

  const EsppRsuData({required this.espp, required this.rsu});

  EsppRsuData copyWith({EsppState? espp, RsuState? rsu}) {
    return EsppRsuData(espp: espp ?? this.espp, rsu: rsu ?? this.rsu);
  }
}

class EsppRsuNotifier extends Notifier<EsppRsuData> {
  @override
  EsppRsuData build() {
    ref.listen(countryProvider, (previous, next) {
      if (previous?.code != next.code) {
        state = esppRsuDefaults[next.code] ?? esppRsuDefaults['us']!;
      }
    });
    final initialCountry = ref.read(countryProvider);
    return esppRsuDefaults[initialCountry.code] ?? esppRsuDefaults['us']!;
  }

  void updateEspp(EsppState newState) {
    state = state.copyWith(espp: newState);
  }

  void updateRsu(RsuState newState) {
    state = state.copyWith(rsu: newState);
  }
}

final esppRsuProvider = NotifierProvider<EsppRsuNotifier, EsppRsuData>(
  () => EsppRsuNotifier(),
);
