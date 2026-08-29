import 'dart:math';
import '../models/formwork_earthwork_model.dart';
import '../models/rate_settings_model.dart';

/// Calculation engine for Excavation, Soil Bulking, Truck Haulage, and Backfill Compaction
class EarthworkService {
  EarthworkService._();

  static EarthworkCalculationResult calculateEarthwork({
    required double excLengthM,
    required double excWidthM,
    required double excDepthM,
    required double bulkingFactorPercent,
    required double truckCapacityM3,
    required double backfillInSituM3,
    required double compactionFactorPercent,
    required RateSettingsModel rates,
  }) {
    // 1. Excavation In-situ
    final inSituExcVolume = excLengthM * excWidthM * excDepthM;

    // 2. Loose volume after excavation bulking (swell)
    final safeBulking = max(0.0, bulkingFactorPercent);
    final looseVolume = inSituExcVolume * (1.0 + (safeBulking / 100.0));

    // 3. Truck trips required
    final safeTruckCap = max(1.0, truckCapacityM3);
    final truckTrips = (looseVolume / safeTruckCap).ceil();

    final excCost = inSituExcVolume * rates.excavationPricePerM3;

    // 4. Backfill with compaction shrinkage
    final safeCompaction = max(0.0, min(80.0, compactionFactorPercent));
    // Borrow volume needed to produce backfillInSituM3 after compaction
    final requiredBorrowVolume = backfillInSituM3 > 0
        ? backfillInSituM3 * (1.0 + (safeCompaction / 100.0))
        : 0.0;

    final backfillCost = requiredBorrowVolume * rates.backfillPricePerM3;
    final totalCost = excCost + backfillCost;

    return EarthworkCalculationResult(
      inSituExcavationVolumeM3: inSituExcVolume,
      bulkingFactorPercent: safeBulking,
      looseVolumeM3: looseVolume,
      truckCapacityM3: safeTruckCap,
      truckTripsNeeded: truckTrips,
      excavationCost: excCost,
      inSituBackfillVolumeM3: backfillInSituM3,
      compactionFactorPercent: safeCompaction,
      requiredBorrowVolumeM3: requiredBorrowVolume,
      backfillCost: backfillCost,
      totalEarthworkCost: totalCost,
    );
  }
}
