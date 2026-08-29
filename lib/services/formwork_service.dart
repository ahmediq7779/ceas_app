import 'dart:math';
import '../models/formwork_earthwork_model.dart';
import '../models/rate_settings_model.dart';

/// Calculation engine for Shuttering and Formwork Contact Area
class FormworkService {
  FormworkService._();

  static const double standardPlywoodAreaM2 = 1.22 * 2.44; // ~2.97688 m²

  static FormworkCalculationResult calculateFormwork({
    required FormworkElementType elementType,
    required double lengthM,
    required double widthM,
    required double heightOrDepthM,
    required int count,
    required int reuseCycles,
    required RateSettingsModel rates,
  }) {
    double singleContactArea = 0.0;

    switch (elementType) {
      case FormworkElementType.slab:
        // Soffit area + perimeter edge forms
        final soffit = lengthM * widthM;
        final edgeForms = 2 * (lengthM + widthM) * heightOrDepthM;
        singleContactArea = soffit + edgeForms;
        break;
      case FormworkElementType.column:
        // 4 vertical sides = 2 * (W + L) * Height
        singleContactArea = 2 * (widthM + lengthM) * heightOrDepthM;
        break;
      case FormworkElementType.beam:
        // Bottom soffit + 2 sides = (W + 2 * H) * Length
        singleContactArea = (widthM + (2 * heightOrDepthM)) * lengthM;
        break;
      case FormworkElementType.footing:
        // Outer vertical perimeter * Depth
        singleContactArea = 2 * (lengthM + widthM) * heightOrDepthM;
        break;
      case FormworkElementType.retainingWall:
        // 2 sides = 2 * (Length * Height) + ends
        singleContactArea = (2 * lengthM * heightOrDepthM) + (2 * widthM * heightOrDepthM);
        break;
    }

    final totalContactArea = singleContactArea * max(1, count);
    final totalPlywoodSheetsNeeded = totalContactArea / standardPlywoodAreaM2;
    final safeReuse = max(1, reuseCycles);
    final netPlywoodToPurchase = (totalPlywoodSheetsNeeded / safeReuse).ceilToDouble();
    final estimatedCost = totalContactArea * rates.formworkPricePerM2;

    return FormworkCalculationResult(
      elementType: elementType,
      contactAreaM2: totalContactArea,
      plywoodSheetsNeeded: totalPlywoodSheetsNeeded,
      reuseCycles: safeReuse,
      netPlywoodSheetsPurchased: netPlywoodToPurchase,
      estimatedCost: estimatedCost,
    );
  }
}
