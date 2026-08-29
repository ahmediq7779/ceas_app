import 'dart:math';
import '../models/concrete_mix_model.dart';
import '../models/masonry_model.dart';
import '../models/rate_settings_model.dart';

/// Calculation engine for Concrete Mix Design and Masonry Blockwork
class ConcreteService {
  ConcreteService._();

  /// Calculates Concrete volume and mix proportions (Cement, Sand, Gravel, Water)
  static ConcreteCalculationResult calculateConcreteMix({
    required ConcreteShape shape,
    required double lengthM,
    required double widthM,
    required double heightOrDepthM,
    required double diameterM,
    required int repeatsCount,
    required double directVolumeM3,
    required double cementRatio,
    required double sandRatio,
    required double gravelRatio,
    required double waterCementRatio,
    required RateSettingsModel rates,
  }) {
    // 1. Calculate Wet Volume
    double singleWetVolume = 0.0;
    switch (shape) {
      case ConcreteShape.slabOrFooting:
      case ConcreteShape.rectangularColumn:
        singleWetVolume = lengthM * widthM * heightOrDepthM;
        break;
      case ConcreteShape.circularColumn:
        final radius = diameterM / 2.0;
        singleWetVolume = pi * radius * radius * heightOrDepthM;
        break;
      case ConcreteShape.directVolume:
        singleWetVolume = directVolumeM3;
        break;
    }

    final totalWetVolume = (shape == ConcreteShape.directVolume)
        ? directVolumeM3
        : (singleWetVolume * max(1, repeatsCount));

    if (totalWetVolume <= 0) {
      return const ConcreteCalculationResult(
        wetVolumeM3: 0,
        dryVolumeM3: 0,
        cementKg: 0,
        cementBags50kg: 0,
        cementVolumeM3: 0,
        sandVolumeM3: 0,
        gravelVolumeM3: 0,
        waterLiters: 0,
        estimatedCost: 0,
      );
    }

    // 2. Wet to Dry Volume (Standard engineering dry factor = 1.54)
    final dryVolume = totalWetVolume * 1.54;

    // 3. Proportions
    final sumOfRatios = cementRatio + sandRatio + gravelRatio;
    final safeRatioSum = sumOfRatios > 0 ? sumOfRatios : 5.5;

    // Cement volume in m³ and mass (Density of dry cement ~ 1440 kg/m³)
    final cementVolume = (cementRatio / safeRatioSum) * dryVolume;
    final cementKg = cementVolume * 1440.0;
    final cementBags = cementKg / 50.0;

    // Sand and Gravel volumes in m³
    final sandVolume = (sandRatio / safeRatioSum) * dryVolume;
    final gravelVolume = (gravelRatio / safeRatioSum) * dryVolume;

    // Water in Liters (W/C ratio * cement mass)
    final safeWcRatio = waterCementRatio > 0 ? waterCementRatio : 0.50;
    final waterLiters = cementKg * safeWcRatio;

    // 4. Cost estimation
    final estimatedCost = (cementBags * rates.cementBagPrice) +
        (sandVolume * rates.sandPricePerM3) +
        (gravelVolume * rates.gravelPricePerM3);

    return ConcreteCalculationResult(
      wetVolumeM3: totalWetVolume,
      dryVolumeM3: dryVolume,
      cementKg: cementKg,
      cementBags50kg: cementBags,
      cementVolumeM3: cementVolume,
      sandVolumeM3: sandVolume,
      gravelVolumeM3: gravelVolume,
      waterLiters: waterLiters,
      estimatedCost: estimatedCost,
    );
  }

  /// Calculates Masonry block quantities, opening deductions, and mortar
  static MasonryCalculationResult calculateMasonry({
    required double wallLengthM,
    required double wallHeightM,
    required double blockLengthCm,
    required double blockHeightCm,
    required double blockWidthCm,
    required double mortarThicknessCm,
    required double wastePercentage,
    required List<WallOpening> openings,
    required RateSettingsModel rates,
  }) {
    final grossArea = wallLengthM * wallHeightM;
    double deductionsArea = 0.0;
    for (final op in openings) {
      deductionsArea += op.totalAreaM2;
    }

    final netArea = max(0.0, grossArea - deductionsArea);
    if (netArea <= 0) {
      return const MasonryCalculationResult(
        grossWallAreaM2: 0,
        deductionsAreaM2: 0,
        netWallAreaM2: 0,
        netBlockCount: 0,
        totalBlocksWithWaste: 0,
        mortarVolumeM3: 0,
        mortarCementBags: 0,
        mortarSandM3: 0,
        totalEstimatedCost: 0,
      );
    }

    // Single block dimensions with mortar joint in meters
    final mortarM = (mortarThicknessCm > 0 ? mortarThicknessCm : 1.0) / 100.0;
    final blockLengthM = (blockLengthCm / 100.0) + mortarM;
    final blockHeightM = (blockHeightCm / 100.0) + mortarM;
    final blockWidthM = blockWidthCm / 100.0;

    final singleBlockFaceArea = blockLengthM * blockHeightM;
    final netBlocks = netArea / singleBlockFaceArea;
    final safeWaste = max(0.0, wastePercentage);
    final totalBlocksWithWaste = netBlocks * (1.0 + (safeWaste / 100.0));

    // Mortar volume estimation
    // Wall volume = Net Area * block width
    // Gross blocks volume = netBlocks * (actual block length * actual block height * block width)
    final actualSingleBlockVol = (blockLengthCm / 100.0) * (blockHeightCm / 100.0) * blockWidthM;
    final wallTotalVol = netArea * blockWidthM;
    final rawMortarVol = max(0.0, wallTotalVol - (netBlocks * actualSingleBlockVol));
    final mortarVolume = rawMortarVol * (1.0 + (safeWaste / 100.0));

    // 1 m³ of 1:3 mortar requires approx 350 kg cement (7 bags) and 1.05 m³ sand
    final mortarCementBags = mortarVolume * 7.0;
    final mortarSandM3 = mortarVolume * 1.05;

    // Cost estimation
    final blockCost = (totalBlocksWithWaste / 1000.0) * rates.blockPricePerThousand;
    final mortarCost = (mortarCementBags * rates.cementBagPrice) + (mortarSandM3 * rates.sandPricePerM3);
    final totalCost = blockCost + mortarCost;

    return MasonryCalculationResult(
      grossWallAreaM2: grossArea,
      deductionsAreaM2: deductionsArea,
      netWallAreaM2: netArea,
      netBlockCount: netBlocks,
      totalBlocksWithWaste: totalBlocksWithWaste,
      mortarVolumeM3: mortarVolume,
      mortarCementBags: mortarCementBags,
      mortarSandM3: mortarSandM3,
      totalEstimatedCost: totalCost,
    );
  }
}
