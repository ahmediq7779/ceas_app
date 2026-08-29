import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/steel_rebar_model.dart';
import '../services/steel_service.dart';
import 'rate_settings_provider.dart';

// 1. Rebar Weight State
class RebarWeightState {
  final int diameterMm;
  final double lengthPerBarM;
  final int barCount;
  final RebarWeightResult? result;

  const RebarWeightState({
    this.diameterMm = 16,
    this.lengthPerBarM = 12.0,
    this.barCount = 50,
    this.result,
  });

  RebarWeightState copyWith({
    int? diameterMm,
    double? lengthPerBarM,
    int? barCount,
    RebarWeightResult? result,
  }) {
    return RebarWeightState(
      diameterMm: diameterMm ?? this.diameterMm,
      lengthPerBarM: lengthPerBarM ?? this.lengthPerBarM,
      barCount: barCount ?? this.barCount,
      result: result ?? this.result,
    );
  }
}

class RebarWeightNotifier extends StateNotifier<RebarWeightState> {
  final Ref _ref;

  RebarWeightNotifier(this._ref) : super(const RebarWeightState()) {
    calculate();
  }

  void updateInputs({int? diameterMm, double? lengthPerBarM, int? barCount}) {
    state = state.copyWith(
      diameterMm: diameterMm,
      lengthPerBarM: lengthPerBarM,
      barCount: barCount,
    );
    calculate();
  }

  void calculate() {
    final rates = _ref.read(rateSettingsProvider);
    final result = SteelService.calculateRebarWeight(
      diameterMm: state.diameterMm,
      lengthPerBarM: state.lengthPerBarM,
      barCount: state.barCount,
      rates: rates,
    );
    state = state.copyWith(result: result);
  }
}

final rebarWeightProvider =
    StateNotifierProvider<RebarWeightNotifier, RebarWeightState>((ref) {
  return RebarWeightNotifier(ref);
});

// 2. Lap Splice State
class LapSpliceState {
  final int diameterMm;
  final double fcMpa;
  final double fyMpa;
  final SpliceType spliceType;
  final bool isTopBar;
  final bool isEpoxyCoated;
  final LapSpliceResult? result;

  const LapSpliceState({
    this.diameterMm = 16,
    this.fcMpa = 25.0,
    this.fyMpa = 420.0,
    this.spliceType = SpliceType.tensionClassB,
    this.isTopBar = false,
    this.isEpoxyCoated = false,
    this.result,
  });

  LapSpliceState copyWith({
    int? diameterMm,
    double? fcMpa,
    double? fyMpa,
    SpliceType? spliceType,
    bool? isTopBar,
    bool? isEpoxyCoated,
    LapSpliceResult? result,
  }) {
    return LapSpliceState(
      diameterMm: diameterMm ?? this.diameterMm,
      fcMpa: fcMpa ?? this.fcMpa,
      fyMpa: fyMpa ?? this.fyMpa,
      spliceType: spliceType ?? this.spliceType,
      isTopBar: isTopBar ?? this.isTopBar,
      isEpoxyCoated: isEpoxyCoated ?? this.isEpoxyCoated,
      result: result ?? this.result,
    );
  }
}

class LapSpliceNotifier extends StateNotifier<LapSpliceState> {
  LapSpliceNotifier() : super(const LapSpliceState()) {
    calculate();
  }

  void updateInputs({
    int? diameterMm,
    double? fcMpa,
    double? fyMpa,
    SpliceType? spliceType,
    bool? isTopBar,
    bool? isEpoxyCoated,
  }) {
    state = state.copyWith(
      diameterMm: diameterMm,
      fcMpa: fcMpa,
      fyMpa: fyMpa,
      spliceType: spliceType,
      isTopBar: isTopBar,
      isEpoxyCoated: isEpoxyCoated,
    );
    calculate();
  }

  void calculate() {
    final result = SteelService.calculateLapSplice(
      diameterMm: state.diameterMm,
      fcMpa: state.fcMpa,
      fyMpa: state.fyMpa,
      spliceType: state.spliceType,
      isTopBar: state.isTopBar,
      isEpoxyCoated: state.isEpoxyCoated,
    );
    state = state.copyWith(result: result);
  }
}

final lapSpliceProvider =
    StateNotifierProvider<LapSpliceNotifier, LapSpliceState>((ref) {
  return LapSpliceNotifier();
});

// 3. Stirrups State
class StirrupsState {
  final double beamWidthM;
  final double beamHeightM;
  final double memberLengthM;
  final double clearCoverMm;
  final int stirrupDiameterMm;
  final StirrupHookType hookType;
  final double spacingCm;
  final StirrupsCalculationResult? result;

  const StirrupsState({
    this.beamWidthM = 0.30,
    this.beamHeightM = 0.60,
    this.memberLengthM = 6.0,
    this.clearCoverMm = 25.0,
    this.stirrupDiameterMm = 8,
    this.hookType = StirrupHookType.seismic135,
    this.spacingCm = 15.0,
    this.result,
  });

  StirrupsState copyWith({
    double? beamWidthM,
    double? beamHeightM,
    double? memberLengthM,
    double? clearCoverMm,
    int? stirrupDiameterMm,
    StirrupHookType? hookType,
    double? spacingCm,
    StirrupsCalculationResult? result,
  }) {
    return StirrupsState(
      beamWidthM: beamWidthM ?? this.beamWidthM,
      beamHeightM: beamHeightM ?? this.beamHeightM,
      memberLengthM: memberLengthM ?? this.memberLengthM,
      clearCoverMm: clearCoverMm ?? this.clearCoverMm,
      stirrupDiameterMm: stirrupDiameterMm ?? this.stirrupDiameterMm,
      hookType: hookType ?? this.hookType,
      spacingCm: spacingCm ?? this.spacingCm,
      result: result ?? this.result,
    );
  }
}

class StirrupsNotifier extends StateNotifier<StirrupsState> {
  final Ref _ref;

  StirrupsNotifier(this._ref) : super(const StirrupsState()) {
    calculate();
  }

  void updateInputs({
    double? beamWidthM,
    double? beamHeightM,
    double? memberLengthM,
    double? clearCoverMm,
    int? stirrupDiameterMm,
    StirrupHookType? hookType,
    double? spacingCm,
  }) {
    state = state.copyWith(
      beamWidthM: beamWidthM,
      beamHeightM: beamHeightM,
      memberLengthM: memberLengthM,
      clearCoverMm: clearCoverMm,
      stirrupDiameterMm: stirrupDiameterMm,
      hookType: hookType,
      spacingCm: spacingCm,
    );
    calculate();
  }

  void calculate() {
    final rates = _ref.read(rateSettingsProvider);
    final result = SteelService.calculateStirrups(
      beamWidthM: state.beamWidthM,
      beamHeightM: state.beamHeightM,
      memberLengthM: state.memberLengthM,
      clearCoverMm: state.clearCoverMm,
      stirrupDiameterMm: state.stirrupDiameterMm,
      hookType: state.hookType,
      spacingCm: state.spacingCm,
      rates: rates,
    );
    state = state.copyWith(result: result);
  }
}

final stirrupsProvider =
    StateNotifierProvider<StirrupsNotifier, StirrupsState>((ref) {
  return StirrupsNotifier(ref);
});
