import 'package:freezed_annotation/freezed_annotation.dart';

part 'simulation_result.freezed.dart';

@freezed
abstract class SimulationResult with _$SimulationResult {
  const factory SimulationResult({
    required List<NetWorthPoint> buyNetWorth,
    required List<NetWorthPoint> rentNetWorth,
    required double finalDifference,
    required List<double> buyCashFlow,
    required List<double> rentCashFlow,
    int? breakevenYear,
  }) = _SimulationResult;
}

@freezed
abstract class NetWorthPoint with _$NetWorthPoint {
  const factory NetWorthPoint({required int year, required double amount}) =
      _NetWorthPoint;
}
