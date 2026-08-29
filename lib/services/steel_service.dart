import 'dart:math';
import '../models/steel_rebar_model.dart';
import '../models/rate_settings_model.dart';

/// Calculation engine for Steel Rebar weights, Lap Splices, and Stirrups
class SteelService {
  SteelService._();

  /// Calculates total rebar weight and stock 12m cutting optimization
  static RebarWeightResult calculateRebarWeight({
    required int diameterMm,
    required double lengthPerBarM,
    required int barCount,
    required RateSettingsModel rates,
  }) {
    final unitWeight = RebarDiameters.unitWeightKgPerM(diameterMm);
    final totalLength = lengthPerBarM * max(0, barCount);
    final totalWeightKg = unitWeight * totalLength;
    final totalWeightTon = totalWeightKg / 1000.0;

    // Stock bar estimation (12m commercial rebar)
    int stockBarsNeeded = 0;
    double scrapPercent = 0.0;
    if (totalLength > 0) {
      stockBarsNeeded = (totalLength / 12.0).ceil();
      final totalStockLength = stockBarsNeeded * 12.0;
      if (totalStockLength > 0) {
        scrapPercent = max(0.0, ((totalStockLength - totalLength) / totalStockLength) * 100.0);
      }
    }

    final estimatedCost = totalWeightTon * rates.rebarPricePerTon;

    return RebarWeightResult(
      diameterMm: diameterMm,
      unitWeightKgPerM: unitWeight,
      lengthPerBarM: lengthPerBarM,
      barCount: barCount,
      totalLengthM: totalLength,
      totalWeightKg: totalWeightKg,
      totalWeightTon: totalWeightTon,
      stock12mBarsNeeded: stockBarsNeeded,
      scrapPercentage: scrapPercent,
      estimatedCost: estimatedCost,
    );
  }

  /// Calculates Lap Splice & Development Length based on ACI 318 / EC2
  static LapSpliceResult calculateLapSplice({
    required int diameterMm,
    required double fcMpa,
    required double fyMpa,
    required SpliceType spliceType,
    required bool isTopBar,
    required bool isEpoxyCoated,
  }) {
    final dbMm = diameterMm.toDouble();
    final safeFc = max(15.0, min(80.0, fcMpa));
    final safeFy = max(240.0, min(600.0, fyMpa));
    final sqrtFc = sqrt(safeFc);

    // Modification factors (ACI 318)
    final psiT = isTopBar ? 1.3 : 1.0;
    final psiE = isEpoxyCoated ? 1.2 : 1.0;

    // Tension Development Length (Ld in mm)
    // Simplified ACI equation: Ld = (fy * psiT * psiE / (1.1 * sqrt(f'c))) * db
    double ldMm = (safeFy * psiT * psiE / (1.1 * sqrtFc)) * dbMm;
    if (ldMm < 300.0) ldMm = 300.0; // ACI minimum = 300mm

    double lsMm = 0.0;
    String note = '';

    switch (spliceType) {
      case SpliceType.tensionClassA:
        lsMm = max(300.0, 1.0 * ldMm);
        note = 'وصلة شد فئة أ (1.0 Ld) - يُسمح بها عندما تكون نسبة الحديد الفعلي إلى المطلوب ≥ 2 ووصل ≤ 50% من الأسياخ';
        break;
      case SpliceType.tensionClassB:
        lsMm = max(300.0, 1.3 * ldMm);
        note = 'وصلة شد فئة ب (1.3 Ld) - الوصلة الشائعة والأكثر أماناً لكافة مناطق الشد الرئيسية';
        break;
      case SpliceType.compression:
        if (safeFy <= 420.0) {
          lsMm = max(300.0, max(0.071 * safeFy * dbMm, 40.0 * dbMm));
        } else {
          lsMm = max(300.0, max((0.13 * safeFy - 24.0) * dbMm, 40.0 * dbMm));
        }
        note = 'وصلة ضغط (Compression) - للأعمدة وعناصر الضغط المحوري فقط بشرط توافر أساور تطويق كافية';
        break;
    }

    final devLengthCm = ldMm / 10.0;
    final lapLengthCm = lsMm / 10.0;
    final lapLengthM = lsMm / 1000.0;
    final barMultiplier = (lsMm / dbMm);

    return LapSpliceResult(
      diameterMm: diameterMm,
      fcMpa: safeFc,
      fyMpa: safeFy,
      spliceType: spliceType,
      developmentLengthCm: devLengthCm,
      lapSpliceLengthCm: lapLengthCm,
      lapSpliceLengthM: lapLengthM,
      barDiameterMultiplier: barMultiplier,
      engineeringNote: note,
    );
  }

  /// Calculates Stirrup cut length, total count, and weight
  static StirrupsCalculationResult calculateStirrups({
    required double beamWidthM,
    required double beamHeightM,
    required double memberLengthM,
    required double clearCoverMm,
    required int stirrupDiameterMm,
    required StirrupHookType hookType,
    required double spacingCm,
    required RateSettingsModel rates,
  }) {
    if (beamWidthM <= 0 || beamHeightM <= 0 || memberLengthM <= 0 || spacingCm <= 0) {
      return const StirrupsCalculationResult(
        beamWidthM: 0,
        beamHeightM: 0,
        memberLengthM: 0,
        clearCoverMm: 0,
        stirrupDiameterMm: 8,
        spacingCm: 0,
        cutLengthPerStirrupM: 0,
        totalStirrupCount: 0,
        totalSteelLengthM: 0,
        totalWeightKg: 0,
        totalWeightTon: 0,
        estimatedCost: 0,
      );
    }

    final coverM = clearCoverMm / 1000.0;
    final dbM = stirrupDiameterMm / 1000.0;

    // Core dimensions
    final coreWidthM = max(0.05, beamWidthM - (2 * coverM));
    final coreHeightM = max(0.05, beamHeightM - (2 * coverM));

    // Hook extensions (2 hooks)
    double hookExtensionPerSideM = 0.0;
    if (hookType == StirrupHookType.seismic135) {
      // 10 db or 75mm minimum
      hookExtensionPerSideM = max(0.075, 10.0 * dbM);
    } else {
      // 6 db or 65mm minimum
      hookExtensionPerSideM = max(0.065, 6.0 * dbM);
    }

    final totalHooksM = 2 * hookExtensionPerSideM;
    final cutLength = (2 * (coreWidthM + coreHeightM)) + totalHooksM;

    // Total stirrups count = (Member Length / spacing) + 1
    final spacingM = spacingCm / 100.0;
    final count = (memberLengthM / spacingM).floor() + 1;

    final totalSteelLength = count * cutLength;
    final unitWeight = RebarDiameters.unitWeightKgPerM(stirrupDiameterMm);
    final totalWeightKg = totalSteelLength * unitWeight;
    final totalWeightTon = totalWeightKg / 1000.0;
    final cost = totalWeightTon * rates.rebarPricePerTon;

    return StirrupsCalculationResult(
      beamWidthM: beamWidthM,
      beamHeightM: beamHeightM,
      memberLengthM: memberLengthM,
      clearCoverMm: clearCoverMm,
      stirrupDiameterMm: stirrupDiameterMm,
      spacingCm: spacingCm,
      cutLengthPerStirrupM: cutLength,
      totalStirrupCount: count,
      totalSteelLengthM: totalSteelLength,
      totalWeightKg: totalWeightKg,
      totalWeightTon: totalWeightTon,
      estimatedCost: cost,
    );
  }
}
