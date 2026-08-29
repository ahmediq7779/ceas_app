/// Steel rebar diameters in mm
class RebarDiameters {
  static const List<int> standard = [
    6, 8, 10, 12, 14, 16, 18, 20, 22, 25, 28, 32, 36, 40
  ];

  /// Unit weight in kg/m: D^2 / 162.28
  static double unitWeightKgPerM(int diameterMm) {
    return (diameterMm * diameterMm) / 162.28;
  }
}

/// Rebar Weight Output Result
class RebarWeightResult {
  final int diameterMm;
  final double unitWeightKgPerM;
  final double lengthPerBarM;
  final int barCount;
  final double totalLengthM;
  final double totalWeightKg;
  final double totalWeightTon;
  final int stock12mBarsNeeded;
  final double scrapPercentage;
  final double estimatedCost;

  const RebarWeightResult({
    required this.diameterMm,
    required this.unitWeightKgPerM,
    required this.lengthPerBarM,
    required this.barCount,
    required this.totalLengthM,
    required this.totalWeightKg,
    required this.totalWeightTon,
    required this.stock12mBarsNeeded,
    required this.scrapPercentage,
    required this.estimatedCost,
  });
}

/// Lap Splice types
enum SpliceType {
  tensionClassA,
  tensionClassB,
  compression,
}

extension SpliceTypeExt on SpliceType {
  String get nameArabic {
    switch (this) {
      case SpliceType.tensionClassA:
        return 'وصلة تراكب شد - الفئة أ (Tension Class A - 1.0 Ld)';
      case SpliceType.tensionClassB:
        return 'وصلة تراكب شد - الفئة ب (Tension Class B - 1.3 Ld)';
      case SpliceType.compression:
        return 'وصلة تراكب ضغط (Compression Splice)';
    }
  }
}

/// Lap Splice & Development Length Result
class LapSpliceResult {
  final int diameterMm;
  final double fcMpa;
  final double fyMpa;
  final SpliceType spliceType;
  final double developmentLengthCm;
  final double lapSpliceLengthCm;
  final double lapSpliceLengthM;
  final double barDiameterMultiplier;
  final String engineeringNote;

  const LapSpliceResult({
    required this.diameterMm,
    required this.fcMpa,
    required this.fyMpa,
    required this.spliceType,
    required this.developmentLengthCm,
    required this.lapSpliceLengthCm,
    required this.lapSpliceLengthM,
    required this.barDiameterMultiplier,
    required this.engineeringNote,
  });
}

/// Stirrup hook type
enum StirrupHookType {
  seismic135,
  standard90,
}

extension StirrupHookTypeExt on StirrupHookType {
  String get nameArabic {
    switch (this) {
      case StirrupHookType.seismic135:
        return 'قفل زلزالي 135° (امتداد 10db لكل طرف)';
      case StirrupHookType.standard90:
        return 'قفل تقليدي 90° (امتداد 6db لكل طرف)';
    }
  }
}

/// Stirrups & Ties Output Result
class StirrupsCalculationResult {
  final double beamWidthM;
  final double beamHeightM;
  final double memberLengthM;
  final double clearCoverMm;
  final int stirrupDiameterMm;
  final double spacingCm;
  final double cutLengthPerStirrupM;
  final int totalStirrupCount;
  final double totalSteelLengthM;
  final double totalWeightKg;
  final double totalWeightTon;
  final double estimatedCost;

  const StirrupsCalculationResult({
    required this.beamWidthM,
    required this.beamHeightM,
    required this.memberLengthM,
    required this.clearCoverMm,
    required this.stirrupDiameterMm,
    required this.spacingCm,
    required this.cutLengthPerStirrupM,
    required this.totalStirrupCount,
    required this.totalSteelLengthM,
    required this.totalWeightKg,
    required this.totalWeightTon,
    required this.estimatedCost,
  });
}
