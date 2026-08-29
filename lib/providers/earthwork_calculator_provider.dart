import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/formwork_earthwork_model.dart';
import '../services/earthwork_service.dart';
import 'rate_settings_provider.dart';

class EarthworkState {
  final double excLengthM;
  final double excWidthM;
  final double excDepthM;
  final double bulkingFactorPercent;
  final double truckCapacityM3;
  final double backfillInSituM3;
  final double compactionFactorPercent;
  final EarthworkCalculationResult? result;

  const EarthworkState({
    this.excLengthM = 15.0,
    this.excWidthM = 10.0,
    this.excDepthM = 2.5,
    this.bulkingFactorPercent = 20.0,
    this.truckCapacityM3 = 16.0,
    this.backfillInSituM3 = 120.0,
    this.compactionFactorPercent = 20.0,
    this.result,
  });

  EarthworkState copyWith({
    double? excLengthM,
    double? excWidthM,
    double? excDepthM,
    double? bulkingFactorPercent,
    double? truckCapacityM3,
    double? backfillInSituM3,
    double? compactionFactorPercent,
    EarthworkCalculationResult? result,
  }) {
    return EarthworkState(
      excLengthM: excLengthM ?? this.excLengthM,
      excWidthM: excWidthM ?? this.excWidthM,
      excDepthM: excDepthM ?? this.excDepthM,
      bulkingFactorPercent: bulkingFactorPercent ?? this.bulkingFactorPercent,
      truckCapacityM3: truckCapacityM3 ?? this.truckCapacityM3,
      backfillInSituM3: backfillInSituM3 ?? this.backfillInSituM3,
      compactionFactorPercent: compactionFactorPercent ?? this.compactionFactorPercent,
      result: result ?? this.result,
    );
  }
}

class EarthworkNotifier extends StateNotifier<EarthworkState> {
  final Ref _ref;

  EarthworkNotifier(this._ref) : super(const EarthworkState()) {
    calculate();
  }

  void updateInputs({
    double? excLengthM,
    double? excWidthM,
    double? excDepthM,
    double? bulkingFactorPercent,
    double? truckCapacityM3,
    double? backfillInSituM3,
    double? compactionFactorPercent,
  }) {
    state = state.copyWith(
      excLengthM: excLengthM,
      excWidthM: excWidthM,
      excDepthM: excDepthM,
      bulkingFactorPercent: bulkingFactorPercent,
      truckCapacityM3: truckCapacityM3,
      backfillInSituM3: backfillInSituM3,
      compactionFactorPercent: compactionFactorPercent,
    );
    calculate();
  }

  void calculate() {
    final rates = _ref.read(rateSettingsProvider);
    final result = EarthworkService.calculateEarthwork(
      excLengthM: state.excLengthM,
      excWidthM: state.excWidthM,
      excDepthM: state.excDepthM,
      bulkingFactorPercent: state.bulkingFactorPercent,
      truckCapacityM3: state.truckCapacityM3,
      backfillInSituM3: state.backfillInSituM3,
      compactionFactorPercent: state.compactionFactorPercent,
      rates: rates,
    );
    state = state.copyWith(result: result);
  }
}

final earthworkProvider =
    StateNotifierProvider<EarthworkNotifier, EarthworkState>((ref) {
  return EarthworkNotifier(ref);
});
