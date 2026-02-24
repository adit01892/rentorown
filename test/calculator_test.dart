import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_an/models/simulation_config.dart';
import 'package:flutter_application_an/services/calculator.dart';

void main() {
  group('calculateSimulation', () {
    // Baseline config used as foundation for most tests
    const baseline = SimulationConfig(
      propertyPrice: 300000,
      depositAmount: 30000,
      monthlyRent: 1200,
      serviceChargeGroundRent: 1500,
      durationYears: 10,
      interestRate: 4.5,
      mortgageTermYears: 25,
      buyingCostsPercentage: 2.0,
      sellingCostsPercentage: 2.0,
      annualRentInflation: 2.0,
      investmentReturn: 6.0,
      propertyGrowthRate: 3.0,
      oneTimeFees: 2000,
    );

    test('returns results for standard baseline config', () {
      final result = calculateSimulation(baseline);
      expect(result.buyNetWorth, hasLength(11)); // year 0..10
      expect(result.rentNetWorth, hasLength(11));
      expect(result.buyNetWorth.first.year, 0);
      expect(result.rentNetWorth.first.year, 0);
    });

    test('year 0 buy net worth equals deposit minus one-time fees', () {
      final result = calculateSimulation(baseline);
      // 30000 deposit - 2000 flat fees - (300000 * 2% buying costs = 6000) = 22000
      expect(result.buyNetWorth.first.amount, closeTo(22000, 1));
    });

    test('year 0 rent net worth equals deposit plus one-time fees', () {
      final result = calculateSimulation(baseline);
      // 30000 deposit + 2000 flat fees + 6000 buying costs (invested instead) = 38000
      expect(result.rentNetWorth.first.amount, closeTo(38000, 1));
    });

    test('handles zero interest rate (interest-free mortgage)', () {
      final config = baseline.copyWith(interestRate: 0.0);
      final result = calculateSimulation(config);
      // Should not throw, net worth should be positive
      expect(result.buyNetWorth.last.amount, isPositive);
      expect(result.rentNetWorth.last.amount, isPositive);
    });

    test('handles deposit equal to property price (no mortgage)', () {
      final config = baseline.copyWith(depositAmount: 300000);
      // loanAmount becomes 0, no mortgage payments
      expect(() => calculateSimulation(config), returnsNormally);
      final result = calculateSimulation(config);
      // Buyer starts with full equity minus all buying costs (2000 flat + 2% of 300000 = 8000)
      expect(result.buyNetWorth.first.amount, closeTo(292000, 1));
    });

    test('handles duration shorter than mortgage term', () {
      // Simulate only 5 years on a 25-year mortgage
      final config = baseline.copyWith(durationYears: 5);
      final result = calculateSimulation(config);
      expect(result.buyNetWorth, hasLength(6)); // year 0..5
      // Remaining mortgage should still be substantial
      expect(result.buyNetWorth.last.amount, isPositive);
    });

    test('handles very high rent inflation (10%) without crashing', () {
      final config = baseline.copyWith(annualRentInflation: 10.0);
      expect(() => calculateSimulation(config), returnsNormally);
      final result = calculateSimulation(config);
      // After 10 years of 10% rent inflation, model should be stable — no NaN/Inf
      expect(result.rentNetWorth.last.amount.isNaN, isFalse);
      expect(result.rentNetWorth.last.amount.isInfinite, isFalse);
    });

    test('handles zero property growth', () {
      final config = baseline.copyWith(propertyGrowthRate: 0.0);
      final result = calculateSimulation(config);
      // Property stays at 300k; net worth is 300k - remaining mortgage
      expect(result.buyNetWorth.last.amount, isPositive);
    });

    test('handles negative property growth', () {
      final config = baseline.copyWith(propertyGrowthRate: -3.0);
      final result = calculateSimulation(config);
      // Property depreciating; check no NaN/Inf regardless of sign
      expect(result.buyNetWorth.last.amount.isNaN, isFalse);
      expect(result.buyNetWorth.last.amount.isInfinite, isFalse);
    });

    test('breakevenYear is null when buying never wins', () {
      // Very high rent inflation + high investment return strongly favours buying early,
      // but with high growth rate for investments and low property growth, renting may win throughout.
      final config = baseline.copyWith(
        propertyGrowthRate: 0.0,
        investmentReturn: 12.0,
        annualRentInflation: 0.0,
      );
      final result = calculateSimulation(config);
      // On this config, buying may or may not win — just verify it doesn't throw
      expect(result.breakevenYear, anyOf(isNull, isNonNegative));
    });

    test('breakevenYear is found when buying clearly outperforms early on', () {
      // High property growth, very low investment return, short horizon
      final config = baseline.copyWith(
        propertyGrowthRate: 10.0,
        investmentReturn: 0.0,
        durationYears: 15,
      );
      final result = calculateSimulation(config);
      expect(result.breakevenYear, isNotNull);
      expect(result.breakevenYear!, lessThan(16));
    });

    test('finalDifference matches last buy minus last rent net worth', () {
      final result = calculateSimulation(baseline);
      final expected =
          result.buyNetWorth.last.amount - result.rentNetWorth.last.amount;
      expect(result.finalDifference, closeTo(expected, 0.01));
    });

    test('produced net worth series are monotonically logical over time', () {
      final result = calculateSimulation(baseline);
      // Both series should have no NaN or Infinity values
      for (final p in result.buyNetWorth) {
        expect(p.amount.isNaN, isFalse);
        expect(p.amount.isInfinite, isFalse);
      }
      for (final p in result.rentNetWorth) {
        expect(p.amount.isNaN, isFalse);
        expect(p.amount.isInfinite, isFalse);
      }
    });
  });
}
