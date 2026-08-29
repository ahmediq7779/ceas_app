/// Block standard dimensions presets in cm (Length x Height x Width/Thickness)
enum BlockStandardPreset {
  block40x20x20,
  block40x20x15,
  block40x20x10,
  custom,
}

extension BlockStandardPresetExt on BlockStandardPreset {
  String get nameArabic {
    switch (this) {
      case BlockStandardPreset.block40x20x20:
        return '40 × 20 × 20 سم (بلوك خرساني مفرغ / مصمت)';
      case BlockStandardPreset.block40x20x15:
        return '40 × 20 × 15 سم (قواطع وجدران داخلية)';
      case BlockStandardPreset.block40x20x10:
        return '40 × 20 × 10 سم (قواطع خفيفة وسواتر)';
      case BlockStandardPreset.custom:
        return 'مقاس بلوك مخصص (Custom Block Size)';
    }
  }

  double get lengthCm => this == BlockStandardPreset.custom ? 40.0 : 40.0;
  double get heightCm => this == BlockStandardPreset.custom ? 20.0 : 20.0;
  double get widthCm {
    switch (this) {
      case BlockStandardPreset.block40x20x20:
        return 20.0;
      case BlockStandardPreset.block40x20x15:
        return 15.0;
      case BlockStandardPreset.block40x20x10:
        return 10.0;
      case BlockStandardPreset.custom:
        return 20.0;
    }
  }
}

/// Deduction opening (doors, windows)
class WallOpening {
  final String id;
  final String label;
  final double widthM;
  final double heightM;
  final int count;

  const WallOpening({
    required this.id,
    required this.label,
    required this.widthM,
    required this.heightM,
    this.count = 1,
  });

  double get totalAreaM2 => widthM * heightM * count;
}

/// Output result for Masonry Block Calculation
class MasonryCalculationResult {
  final double grossWallAreaM2;
  final double deductionsAreaM2;
  final double netWallAreaM2;
  final double netBlockCount;
  final double totalBlocksWithWaste;
  final double mortarVolumeM3;
  final double mortarCementBags;
  final double mortarSandM3;
  final double totalEstimatedCost;

  const MasonryCalculationResult({
    required this.grossWallAreaM2,
    required this.deductionsAreaM2,
    required this.netWallAreaM2,
    required this.netBlockCount,
    required this.totalBlocksWithWaste,
    required this.mortarVolumeM3,
    required this.mortarCementBags,
    required this.mortarSandM3,
    required this.totalEstimatedCost,
  });
}
