import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/concrete_mix_model.dart';
import '../models/masonry_model.dart';
import '../services/concrete_service.dart';
import 'rate_settings_provider.dart';

// Concrete Mix State
class ConcreteMixState {
  final ConcreteShape shape;
  final double lengthM;
  final double widthM;
  final double heightOrDepthM;
  final double diameterM;
  final int repeatsCount;
  final double directVolumeM3;
  final ConcreteMixPreset preset;
  final double cementRatio;
  final double sandRatio;
  final double gravelRatio;
  final double waterCementRatio;
  final ConcreteCalculationResult? result;

  const ConcreteMixState({
    this.shape = ConcreteShape.slabOrFooting,
    this.lengthM = 10.0,
    this.widthM = 5.0,
    this.heightOrDepthM = 0.20,
    this.diameterM = 0.50,
    this.repeatsCount = 1,
    this.directVolumeM3 = 10.0,
    this.preset = ConcreteMixPreset.c25,
    this.cementRatio = 1.0,
    this.sandRatio = 1.5,
    this.gravelRatio = 3.0,
    this.waterCementRatio = 0.50,
    this.result,
  });

  ConcreteMixState copyWith({
    ConcreteShape? shape,
    double? lengthM,
    double? widthM,
    double? heightOrDepthM,
    double? diameterM,
    int? repeatsCount,
    double? directVolumeM3,
    ConcreteMixPreset? preset,
    double? cementRatio,
    double? sandRatio,
    double? gravelRatio,
    double? waterCementRatio,
    ConcreteCalculationResult? result,
  }) {
    return ConcreteMixState(
      shape: shape ?? this.shape,
      lengthM: lengthM ?? this.lengthM,
      widthM: widthM ?? this.widthM,
      heightOrDepthM: heightOrDepthM ?? this.heightOrDepthM,
      diameterM: diameterM ?? this.diameterM,
      repeatsCount: repeatsCount ?? this.repeatsCount,
      directVolumeM3: directVolumeM3 ?? this.directVolumeM3,
      preset: preset ?? this.preset,
      cementRatio: cementRatio ?? this.cementRatio,
      sandRatio: sandRatio ?? this.sandRatio,
      gravelRatio: gravelRatio ?? this.gravelRatio,
      waterCementRatio: waterCementRatio ?? this.waterCementRatio,
      result: result ?? this.result,
    );
  }
}

class ConcreteMixNotifier extends StateNotifier<ConcreteMixState> {
  final Ref _ref;

  ConcreteMixNotifier(this._ref) : super(const ConcreteMixState()) {
    calculate();
  }

  void updateShape(ConcreteShape shape) {
    state = state.copyWith(shape: shape);
    calculate();
  }

  void updateDimensions({
    double? lengthM,
    double? widthM,
    double? heightOrDepthM,
    double? diameterM,
    int? repeatsCount,
    double? directVolumeM3,
  }) {
    state = state.copyWith(
      lengthM: lengthM,
      widthM: widthM,
      heightOrDepthM: heightOrDepthM,
      diameterM: diameterM,
      repeatsCount: repeatsCount,
      directVolumeM3: directVolumeM3,
    );
    calculate();
  }

  void updatePreset(ConcreteMixPreset preset) {
    if (preset != ConcreteMixPreset.custom) {
      state = state.copyWith(
        preset: preset,
        cementRatio: preset.cementRatio,
        sandRatio: preset.sandRatio,
        gravelRatio: preset.gravelRatio,
      );
    } else {
      state = state.copyWith(preset: preset);
    }
    calculate();
  }

  void updateRatios({
    double? cementRatio,
    double? sandRatio,
    double? gravelRatio,
    double? waterCementRatio,
  }) {
    state = state.copyWith(
      cementRatio: cementRatio,
      sandRatio: sandRatio,
      gravelRatio: gravelRatio,
      waterCementRatio: waterCementRatio,
      preset: ConcreteMixPreset.custom,
    );
    calculate();
  }

  void calculate() {
    final rates = _ref.read(rateSettingsProvider);
    final result = ConcreteService.calculateConcreteMix(
      shape: state.shape,
      lengthM: state.lengthM,
      widthM: state.widthM,
      heightOrDepthM: state.heightOrDepthM,
      diameterM: state.diameterM,
      repeatsCount: state.repeatsCount,
      directVolumeM3: state.directVolumeM3,
      cementRatio: state.cementRatio,
      sandRatio: state.sandRatio,
      gravelRatio: state.gravelRatio,
      waterCementRatio: state.waterCementRatio,
      rates: rates,
    );
    state = state.copyWith(result: result);
  }
}

final concreteMixProvider =
    StateNotifierProvider<ConcreteMixNotifier, ConcreteMixState>((ref) {
  return ConcreteMixNotifier(ref);
});

// Masonry State
class MasonryState {
  final double wallLengthM;
  final double wallHeightM;
  final BlockStandardPreset blockPreset;
  final double blockLengthCm;
  final double blockHeightCm;
  final double blockWidthCm;
  final double mortarThicknessCm;
  final double wastePercentage;
  final List<WallOpening> openings;
  final MasonryCalculationResult? result;

  const MasonryState({
    this.wallLengthM = 10.0,
    this.wallHeightM = 3.0,
    this.blockPreset = BlockStandardPreset.block40x20x20,
    this.blockLengthCm = 40.0,
    this.blockHeightCm = 20.0,
    this.blockWidthCm = 20.0,
    this.mortarThicknessCm = 1.5,
    this.wastePercentage = 5.0,
    this.openings = const [
      WallOpening(id: '1', label: 'باب رئيسي (1×2.2م)', widthM: 1.0, heightM: 2.2, count: 1),
    ],
    this.result,
  });

  MasonryState copyWith({
    double? wallLengthM,
    double? wallHeightM,
    BlockStandardPreset? blockPreset,
    double? blockLengthCm,
    double? blockHeightCm,
    double? blockWidthCm,
    double? mortarThicknessCm,
    double? wastePercentage,
    List<WallOpening>? openings,
    MasonryCalculationResult? result,
  }) {
    return MasonryState(
      wallLengthM: wallLengthM ?? this.wallLengthM,
      wallHeightM: wallHeightM ?? this.wallHeightM,
      blockPreset: blockPreset ?? this.blockPreset,
      blockLengthCm: blockLengthCm ?? this.blockLengthCm,
      blockHeightCm: blockHeightCm ?? this.blockHeightCm,
      blockWidthCm: blockWidthCm ?? this.blockWidthCm,
      mortarThicknessCm: mortarThicknessCm ?? this.mortarThicknessCm,
      wastePercentage: wastePercentage ?? this.wastePercentage,
      openings: openings ?? this.openings,
      result: result ?? this.result,
    );
  }
}

class MasonryNotifier extends StateNotifier<MasonryState> {
  final Ref _ref;

  MasonryNotifier(this._ref) : super(const MasonryState()) {
    calculate();
  }

  void updateDimensions({
    double? wallLengthM,
    double? wallHeightM,
    double? mortarThicknessCm,
    double? wastePercentage,
  }) {
    state = state.copyWith(
      wallLengthM: wallLengthM,
      wallHeightM: wallHeightM,
      mortarThicknessCm: mortarThicknessCm,
      wastePercentage: wastePercentage,
    );
    calculate();
  }

  void updateBlockPreset(BlockStandardPreset preset) {
    if (preset != BlockStandardPreset.custom) {
      state = state.copyWith(
        blockPreset: preset,
        blockLengthCm: preset.lengthCm,
        blockHeightCm: preset.heightCm,
        blockWidthCm: preset.widthCm,
      );
    } else {
      state = state.copyWith(blockPreset: preset);
    }
    calculate();
  }

  void updateCustomBlockSize({
    double? lengthCm,
    double? heightCm,
    double? widthCm,
  }) {
    state = state.copyWith(
      blockPreset: BlockStandardPreset.custom,
      blockLengthCm: lengthCm,
      blockHeightCm: heightCm,
      blockWidthCm: widthCm,
    );
    calculate();
  }

  void addOpening(WallOpening opening) {
    state = state.copyWith(openings: [...state.openings, opening]);
    calculate();
  }

  void removeOpening(String id) {
    state = state.copyWith(
      openings: state.openings.where((op) => op.id != id).toList(),
    );
    calculate();
  }

  void calculate() {
    final rates = _ref.read(rateSettingsProvider);
    final result = ConcreteService.calculateMasonry(
      wallLengthM: state.wallLengthM,
      wallHeightM: state.wallHeightM,
      blockLengthCm: state.blockLengthCm,
      blockHeightCm: state.blockHeightCm,
      blockWidthCm: state.blockWidthCm,
      mortarThicknessCm: state.mortarThicknessCm,
      wastePercentage: state.wastePercentage,
      openings: state.openings,
      rates: rates,
    );
    state = state.copyWith(result: result);
  }
}

final masonryProvider =
    StateNotifierProvider<MasonryNotifier, MasonryState>((ref) {
  return MasonryNotifier(ref);
});
