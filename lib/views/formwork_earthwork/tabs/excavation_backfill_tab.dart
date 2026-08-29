import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/haptic_service.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/result_card.dart';
import '../../../core/widgets/section_card.dart';
import '../../../models/boq_item_model.dart';
import '../../../providers/boq_provider.dart';
import '../../../providers/earthwork_calculator_provider.dart';
import '../../../providers/rate_settings_provider.dart';

class ExcavationBackfillTab extends ConsumerStatefulWidget {
  const ExcavationBackfillTab({Key? key}) : super(key: key);

  @override
  ConsumerState<ExcavationBackfillTab> createState() => _ExcavationBackfillTabState();
}

class _ExcavationBackfillTabState extends ConsumerState<ExcavationBackfillTab> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _excLengthController;
  late TextEditingController _excWidthController;
  late TextEditingController _excDepthController;
  late TextEditingController _bulkingController;
  late TextEditingController _truckCapController;

  late TextEditingController _backfillVolController;
  late TextEditingController _compactionController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(earthworkProvider);
    _excLengthController = TextEditingController(text: state.excLengthM.toString());
    _excWidthController = TextEditingController(text: state.excWidthM.toString());
    _excDepthController = TextEditingController(text: state.excDepthM.toString());
    _bulkingController = TextEditingController(text: state.bulkingFactorPercent.toString());
    _truckCapController = TextEditingController(text: state.truckCapacityM3.toString());

    _backfillVolController = TextEditingController(text: state.backfillInSituM3.toString());
    _compactionController = TextEditingController(text: state.compactionFactorPercent.toString());
  }

  @override
  void dispose() {
    _excLengthController.dispose();
    _excWidthController.dispose();
    _excDepthController.dispose();
    _bulkingController.dispose();
    _truckCapController.dispose();
    _backfillVolController.dispose();
    _compactionController.dispose();
    super.dispose();
  }

  void _onInputsChanged() {
    ref.read(earthworkProvider.notifier).updateInputs(
      excLengthM: NumberFormatter.parseDouble(_excLengthController.text, defaultValue: 15.0),
      excWidthM: NumberFormatter.parseDouble(_excWidthController.text, defaultValue: 10.0),
      excDepthM: NumberFormatter.parseDouble(_excDepthController.text, defaultValue: 2.5),
      bulkingFactorPercent: NumberFormatter.parseDouble(_bulkingController.text, defaultValue: 20.0),
      truckCapacityM3: NumberFormatter.parseDouble(_truckCapController.text, defaultValue: 16.0),
      backfillInSituM3: NumberFormatter.parseDouble(_backfillVolController.text, defaultValue: 0.0),
      compactionFactorPercent: NumberFormatter.parseDouble(_compactionController.text, defaultValue: 20.0),
    );
  }

  void _addToBoq() {
    final state = ref.read(earthworkProvider);
    final rates = ref.read(rateSettingsProvider);
    final res = state.result;
    if (res == null || (res.inSituExcavationVolumeM3 <= 0 && res.requiredBorrowVolumeM3 <= 0)) return;

    if (res.inSituExcavationVolumeM3 > 0) {
      final excItem = BoqItemModel(
        id: '${DateTime.now().millisecondsSinceEpoch}_exc',
        category: BoqCategory.earthwork,
        title: 'أعمال حفر ونقل ناتج الحفر',
        description: 'حفر في مختلف أنواع التربة لعمق ${state.excDepthM} م بحجم ${NumberFormatter.format(res.inSituExcavationVolumeM3)} م³ ونقل ${NumberFormatter.format(res.looseVolumeM3)} م³ مفكك إلى المقالب العمومية (عدد ${res.truckTripsNeeded} نقلة)',
        unit: AppStrings.unitM3,
        quantity: res.inSituExcavationVolumeM3,
        unitPrice: rates.excavationPricePerM3,
        totalPrice: res.excavationCost,
        createdAt: DateTime.now(),
      );
      ref.read(boqProvider.notifier).addItem(excItem);
    }

    if (res.requiredBorrowVolumeM3 > 0) {
      final backfillItem = BoqItemModel(
        id: '${DateTime.now().millisecondsSinceEpoch}_backfill',
        category: BoqCategory.earthwork,
        title: 'أعمال ردم وتوريد تربة نظيفة مع الدمك',
        description: 'توريد مواد ردم معتمدة وفردها على طبقات والدمك الميكانيكي لحجم صافي ${NumberFormatter.format(res.inSituBackfillVolumeM3)} م³ (كمية المورد المطلوب: ${NumberFormatter.format(res.requiredBorrowVolumeM3)} م³ مع معامل دمك ${state.compactionFactorPercent}%)',
        unit: AppStrings.unitM3,
        quantity: res.requiredBorrowVolumeM3,
        unitPrice: rates.backfillPricePerM3,
        totalPrice: res.backfillCost,
        createdAt: DateTime.now(),
      );
      ref.read(boqProvider.notifier).addItem(backfillItem);
    }

    HapticService.success();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(AppStrings.addedToBoqSuccess),
          ],
        ),
        backgroundColor: AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(earthworkProvider);
    final rates = ref.watch(rateSettingsProvider);
    final result = state.result;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Excavation Parameters
            SectionCard(
              title: AppStrings.excavation,
              icon: Icons.landslide_outlined,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _excLengthController,
                          label: AppStrings.excLength,
                          hint: '15.0',
                          suffixUnit: AppStrings.unitM,
                          validator: Validators.positiveDouble,
                          onChanged: (_) => _onInputsChanged(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _excWidthController,
                          label: AppStrings.excWidth,
                          hint: '10.0',
                          suffixUnit: AppStrings.unitM,
                          validator: Validators.positiveDouble,
                          onChanged: (_) => _onInputsChanged(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _excDepthController,
                          label: AppStrings.excDepth,
                          hint: '2.50',
                          suffixUnit: AppStrings.unitM,
                          validator: Validators.positiveDouble,
                          onChanged: (_) => _onInputsChanged(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _bulkingController,
                          label: AppStrings.soilBulkingFactor,
                          hint: '20',
                          suffixUnit: '%',
                          validator: Validators.percentage,
                          onChanged: (_) => _onInputsChanged(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _truckCapController,
                    label: AppStrings.truckCapacity,
                    hint: '16',
                    suffixUnit: AppStrings.unitM3,
                    prefixIcon: Icons.local_shipping_outlined,
                    validator: Validators.positiveDouble,
                    onChanged: (_) => _onInputsChanged(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Backfill Parameters
            SectionCard(
              title: AppStrings.backfilling,
              icon: Icons.compress_rounded,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _backfillVolController,
                          label: 'حجم الردم الهندسي المطلوب بعد الدمك',
                          hint: '120.0',
                          suffixUnit: AppStrings.unitM3,
                          validator: (v) => Validators.positiveDouble(v, allowZero: true),
                          onChanged: (_) => _onInputsChanged(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _compactionController,
                          label: AppStrings.compactionFactor,
                          hint: '20',
                          suffixUnit: '%',
                          validator: Validators.percentage,
                          onChanged: (_) => _onInputsChanged(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Results Card
            if (result != null) ...[
              ResultCard(
                title: 'نتائج حسابات الحفر والردم والتربة',
                headerIcon: Icons.terrain_rounded,
                items: [
                  ResultItem(
                    label: AppStrings.compactedVolume,
                    value: NumberFormatter.format(result.inSituExcavationVolumeM3),
                    unit: AppStrings.unitM3,
                    subtitle: 'حجم الحفر النظري في مكانه الطبيعي (Bank Measure)',
                    icon: Icons.grid_view_rounded,
                  ),
                  ResultItem(
                    label: AppStrings.looseVolume,
                    value: NumberFormatter.format(result.looseVolumeM3),
                    unit: AppStrings.unitM3,
                    subtitle: 'الحجم المنتفش الواجب نقله خارج الموقع (+${state.bulkingFactorPercent}% انتفاش)',
                    isHighlight: true,
                    icon: Icons.open_with_rounded,
                  ),
                  ResultItem(
                    label: AppStrings.truckTripsNeeded,
                    value: '${result.truckTripsNeeded}',
                    unit: AppStrings.unitTrips,
                    subtitle: 'على أساس سعة شاحنة ${state.truckCapacityM3} م³',
                    isHighlight: true,
                    icon: Icons.local_shipping_outlined,
                  ),
                  ResultItem(
                    label: AppStrings.requiredBorrowVolume,
                    value: NumberFormatter.format(result.requiredBorrowVolumeM3),
                    unit: AppStrings.unitM3,
                    subtitle: 'الكمية المطلوب شراؤها وتوريدها للردم لتعويض هبوط الدمك (+${state.compactionFactorPercent}%)',
                    icon: Icons.add_business_outlined,
                  ),
                ],
                totalCostText: NumberFormatter.formatCurrency(result.totalEarthworkCost, symbol: rates.currency),
                onAddToBoq: _addToBoq,
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
