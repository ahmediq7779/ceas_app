import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/utils/haptic_service.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/result_card.dart';
import '../../../core/widgets/section_card.dart';
import '../../../models/boq_item_model.dart';
import '../../../models/steel_rebar_model.dart';
import '../../../providers/boq_provider.dart';
import '../../../providers/rate_settings_provider.dart';
import '../../../providers/steel_calculator_provider.dart';

class RebarWeightTab extends ConsumerStatefulWidget {
  const RebarWeightTab({Key? key}) : super(key: key);

  @override
  ConsumerState<RebarWeightTab> createState() => _RebarWeightTabState();
}

class _RebarWeightTabState extends ConsumerState<RebarWeightTab> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _lengthController;
  late TextEditingController _countController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(rebarWeightProvider);
    _lengthController = TextEditingController(text: state.lengthPerBarM.toString());
    _countController = TextEditingController(text: state.barCount.toString());
  }

  @override
  void dispose() {
    _lengthController.dispose();
    _countController.dispose();
    super.dispose();
  }

  void _onInputsChanged() {
    ref.read(rebarWeightProvider.notifier).updateInputs(
      lengthPerBarM: NumberFormatter.parseDouble(_lengthController.text, defaultValue: 12.0),
      barCount: NumberFormatter.parseInt(_countController.text, defaultValue: 1),
    );
  }

  void _addToBoq() {
    final state = ref.read(rebarWeightProvider);
    final rates = ref.read(rateSettingsProvider);
    final res = state.result;
    if (res == null || res.totalWeightKg <= 0) return;

    final item = BoqItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: BoqCategory.steel,
      title: 'حديد تسليح عالي المقاومة (Φ ${state.diameterMm} مم)',
      description: 'توريد وتركيب حديد تسليح قطر ${state.diameterMm} مم بطول إجمالي ${NumberFormatter.format(res.totalLengthM)} م (عدد ${res.barCount} سيخ بطول ${res.lengthPerBarM} م) - إجمالي الوزن: ${NumberFormatter.format(res.totalWeightKg)} كجم (${NumberFormatter.format(res.totalWeightTon)} طن)',
      unit: AppStrings.unitTon,
      quantity: res.totalWeightTon,
      unitPrice: rates.rebarPricePerTon,
      totalPrice: res.estimatedCost,
      createdAt: DateTime.now(),
    );

    ref.read(boqProvider.notifier).addItem(item);
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
    final state = ref.watch(rebarWeightProvider);
    final rates = ref.watch(rateSettingsProvider);
    final result = state.result;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Diameter Selection Grid / Chips
            SectionCard(
              title: AppStrings.rebarDiameter,
              icon: Icons.lens_blur_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اختر قطر سيخ التسليح القياسي (مم):',
                    style: AppStyles.bodySmall.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: RebarDiameters.standard.map((d) {
                      final isSelected = state.diameterMm == d;
                      return InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          HapticService.selection();
                          ref.read(rebarWeightProvider.notifier).updateInputs(diameterMm: d);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryOrange
                                : (isDark ? AppColors.darkSlate950 : AppColors.lightCard),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryOrange
                                  : (isDark ? AppColors.darkSlate700 : AppColors.lightBorder),
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Text(
                            'Φ $d',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Length and Count Section
            SectionCard(
              title: 'الأطوال والأعداد',
              icon: Icons.format_list_numbered_rounded,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _lengthController,
                          label: AppStrings.barLength,
                          hint: '12.0',
                          suffixUnit: AppStrings.unitM,
                          prefixIcon: Icons.straighten_rounded,
                          validator: Validators.positiveDouble,
                          onChanged: (_) => _onInputsChanged(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _countController,
                          label: AppStrings.barCount,
                          hint: '50',
                          suffixUnit: 'أسياخ',
                          prefixIcon: Icons.tag_rounded,
                          validator: Validators.positiveInt,
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
                title: 'نتائج حصر أوزان حديد التسليح',
                headerIcon: Icons.scale_rounded,
                items: [
                  ResultItem(
                    label: AppStrings.unitWeight,
                    value: NumberFormatter.format(result.unitWeightKgPerM, maxDecimals: 3),
                    unit: 'كجم/م',
                    subtitle: 'معادلة الوزن المتر الطولي = (Φ² / 162.28)',
                    icon: Icons.fitness_center_rounded,
                  ),
                  ResultItem(
                    label: AppStrings.totalRebarLength,
                    value: NumberFormatter.format(result.totalLengthM),
                    unit: AppStrings.unitM,
                    icon: Icons.linear_scale_rounded,
                  ),
                  ResultItem(
                    label: AppStrings.totalWeightKg,
                    value: NumberFormatter.format(result.totalWeightKg),
                    unit: AppStrings.unitKg,
                    icon: Icons.monitor_weight_outlined,
                  ),
                  ResultItem(
                    label: AppStrings.totalWeightTon,
                    value: NumberFormatter.format(result.totalWeightTon, maxDecimals: 3),
                    unit: AppStrings.unitTon,
                    isHighlight: true,
                    icon: Icons.local_shipping_outlined,
                  ),
                  ResultItem(
                    label: AppStrings.stockBarsCount,
                    value: '${result.stock12mBarsNeeded}',
                    unit: 'سيخ 12م',
                    subtitle: 'الفاقد التقريبي من التقطيع: ${NumberFormatter.format(result.scrapPercentage)}%',
                    icon: Icons.cut_rounded,
                  ),
                ],
                totalCostText: NumberFormatter.formatCurrency(result.estimatedCost, symbol: rates.currency),
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
