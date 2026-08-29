/// Concrete element shapes
enum ConcreteShape {
  slabOrFooting,
  rectangularColumn,
  circularColumn,
  directVolume,
}

/// Standard Mix Presets
enum ConcreteMixPreset {
  c25, // 1 : 1.5 : 3 (M25 / C25)
  c20, // 1 : 2 : 4   (M20 / C20)
  c30, // 1 : 1 : 2   (M30 / C30)
  c15, // 1 : 3 : 6   (M15 / Lean / PCC)
  custom,
}

extension ConcreteMixPresetExt on ConcreteMixPreset {
  String get nameArabic {
    switch (this) {
      case ConcreteMixPreset.c25:
        return 'C25 / M25 (1 : 1.5 : 3) خرسانة مسلحة قياسية';
      case ConcreteMixPreset.c20:
        return 'C20 / M20 (1 : 2 : 4) خرسانة عادية ومسلحة خفيفة';
      case ConcreteMixPreset.c30:
        return 'C30 / M30 (1 : 1 : 2) خرسانة عالية المقاومة';
      case ConcreteMixPreset.c15:
        return 'C15 / M15 (1 : 3 : 6) خرسانة نظافة وقواعد عادية';
      case ConcreteMixPreset.custom:
        return 'نسبة خلط مخصصة (Custom Ratio)';
    }
  }

  double get cementRatio {
    switch (this) {
      case ConcreteMixPreset.c25:
      case ConcreteMixPreset.c20:
      case ConcreteMixPreset.c30:
      case ConcreteMixPreset.c15:
        return 1.0;
      case ConcreteMixPreset.custom:
        return 1.0;
    }
  }

  double get sandRatio {
    switch (this) {
      case ConcreteMixPreset.c25:
        return 1.5;
      case ConcreteMixPreset.c20:
        return 2.0;
      case ConcreteMixPreset.c30:
        return 1.0;
      case ConcreteMixPreset.c15:
        return 3.0;
      case ConcreteMixPreset.custom:
        return 1.5;
    }
  }

  double get gravelRatio {
    switch (this) {
      case ConcreteMixPreset.c25:
        return 3.0;
      case ConcreteMixPreset.c20:
        return 4.0;
      case ConcreteMixPreset.c30:
        return 2.0;
      case ConcreteMixPreset.c15:
        return 6.0;
      case ConcreteMixPreset.custom:
        return 3.0;
    }
  }
}

/// Output results from Concrete calculation engine
class ConcreteCalculationResult {
  final double wetVolumeM3; // m³
  final double dryVolumeM3; // m³ (wetVolume * 1.54)
  final double cementKg; // kg
  final double cementBags50kg; // 50kg bags
  final double cementVolumeM3; // m³
  final double sandVolumeM3; // m³
  final double gravelVolumeM3; // m³
  final double waterLiters; // Liters
  final double estimatedCost; // Currency amount

  const ConcreteCalculationResult({
    required this.wetVolumeM3,
    required this.dryVolumeM3,
    required this.cementKg,
    required this.cementBags50kg,
    required this.cementVolumeM3,
    required this.sandVolumeM3,
    required this.gravelVolumeM3,
    required this.waterLiters,
    required this.estimatedCost,
  });
}
