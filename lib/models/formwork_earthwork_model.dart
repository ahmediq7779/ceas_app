/// Formwork structural element type
enum FormworkElementType {
  slab,
  column,
  beam,
  footing,
  retainingWall,
}

extension FormworkElementTypeExt on FormworkElementType {
  String get nameArabic {
    switch (this) {
      case FormworkElementType.slab:
        return 'بلاطة سقف (قاع البلاطة + حواف الصب)';
      case FormworkElementType.column:
        return 'أعمدة مستطيلة (الأوجه الأربعة)';
      case FormworkElementType.beam:
        return 'كمرات وسواقط (القاع + الجانبين)';
      case FormworkElementType.footing:
        return 'قواعد وميد خرسانية (المحيط الخارجي)';
      case FormworkElementType.retainingWall:
        return 'جدران استنادية / قص (الوجهين)';
    }
  }
}

/// Formwork Calculation Result
class FormworkCalculationResult {
  final FormworkElementType elementType;
  final double contactAreaM2;
  final double plywoodSheetsNeeded; // Based on standard 1.22m x 2.44m (2.977 m²)
  final int reuseCycles;
  final double netPlywoodSheetsPurchased;
  final double estimatedCost;

  const FormworkCalculationResult({
    required this.elementType,
    required this.contactAreaM2,
    required this.plywoodSheetsNeeded,
    required this.reuseCycles,
    required this.netPlywoodSheetsPurchased,
    required this.estimatedCost,
  });
}

/// Earthwork Calculation Result (Excavation & Backfill)
class EarthworkCalculationResult {
  final double inSituExcavationVolumeM3; // Compacted in-place bank volume
  final double bulkingFactorPercent; // Swell factor (e.g. 20%)
  final double looseVolumeM3; // Bulked volume for transport
  final double truckCapacityM3;
  final int truckTripsNeeded;
  final double excavationCost;

  final double inSituBackfillVolumeM3; // Required compacted backfill
  final double compactionFactorPercent; // Shrinkage factor (e.g. 20%)
  final double requiredBorrowVolumeM3; // Loose material to purchase
  final double backfillCost;

  final double totalEarthworkCost;

  const EarthworkCalculationResult({
    required this.inSituExcavationVolumeM3,
    required this.bulkingFactorPercent,
    required this.looseVolumeM3,
    required this.truckCapacityM3,
    required this.truckTripsNeeded,
    required this.excavationCost,
    required this.inSituBackfillVolumeM3,
    required this.compactionFactorPercent,
    required this.requiredBorrowVolumeM3,
    required this.backfillCost,
    required this.totalEarthworkCost,
  });
}
