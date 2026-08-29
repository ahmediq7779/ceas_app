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
import '../../../models/steel_rebar_model.dart';
import '../../../providers/boq_provider.dart';
import '../../../providers/rate_settings_provider.dart';
import '../../../providers/steel_calculator_provider.dart';

class StirrupsTiesTab extends ConsumerStatefulWidget {
  const StirrupsTiesTab({Key? key}) : super(key: key);

  @override
  ConsumerState<StirrupsTiesTab> createState() => _StirrupsTiesTabState();
}

class _StirrupsTiesTabState extends ConsumerState<StirrupsTiesTab> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _widthController;
  late TextEditingController _heightController;
  late TextEditingController _lengthController;
  late TextEditingController _coverController;
  late TextEditingController _spacingController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(stirrupsProvider);
    _widthController = TextEditingController(text: state.beamWidthM.toString());
    _heightController = TextEditingController(text: state.beamHeightM.toString());
    _lengthController = TextEditingController(text: state.memberLengthM.toString());
    _coverController = TextEditingController(text: state.clearCoverMm.toString());
    _spacingController = TextEditingController(text: state.spacingCm.toString());
  }

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    _lengthController.dispose();
    _coverController.dispose();
    _spacingController.dispose();
    super.dispose();
  }

  void _onInputsChanged() {
    ref.read(stirrupsProvider.notifier).updateInputs(
      beamWidthM: NumberFormatter.parseDouble(_widthController.text, defaultValue: 0.30),
      beamHeightM: NumberFormatter.parseDouble(_heightController.text, defaultValue: 0.60),
      memberLengthM: NumberFormatter.parseDouble(_lengthController.text, defaultValue: 6.0),
      clearCoverMm: NumberFormatter.parseDouble(_coverController.text, defaultValue: 25.0),
      spacingCm: NumberFormatter.parseDouble(_spacingController.text, defaultValue: 15.0),
    );
  }

  void _addToBoq() {
    final state = ref.read(stirrupsProvider);
    final rates = ref.read(rateSettingsProvider);
    final res = state.result;
    if (res == null || res.totalWeightKg <= 0) return;

    final item = BoqItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: BoqCategory.steel,
      title: 'كانات وأساور خرسانية (Φ ${state.stirrupDiameterMm} مم)',
      description: 'تصنيع وتثبيت عدد ${res.totalStirrupCount} كانة بمقاس مقطع ${res.beamWidthM}×${res.beamHeightM} م وبطول إجمالي ${NumberFormatter.format(res.totalSteelLengthM)} م - إجمالي الوزن: ${NumberFormatter.format(res.totalWeightKg)} كجم (${NumberFormatter.format(res.totalWeightTon)} طن)',
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
    final state = ref.watch(stirrupsProvider);
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
            // Cross-Section Dimensions
            SectionCard(
              title: 'أبعاد المقطع والعنصر الإنشائي',
              icon: Icons.aspect_ratio_rounded,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _widthController,
                          label: AppStrings.beamColumnWidth,
                          hint: '0.30',
                          suffixUnit: AppStrings.unitM,
                          validator: Validators.positiveDouble,
                          onChanged: (_) => _onInputsChanged(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _heightController,
                          label: AppStrings.beamColumnHeight,
                          hint: '0.60',
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
                          controller: _lengthController,
                          label: AppStrings.memberLength,
                          hint: '6.00',
                          suffixUnit: AppStrings.unitM,
                          validator: Validators.positiveDouble,
                          onChanged: (_) => _onInputsChanged(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _coverController,
                          label: AppStrings.clearCover,
                          hint: '25',
                          suffixUnit: AppStrings.unitMm,
                          validator: Validators.positiveDouble,
                          onChanged: (_) => _onInputsChanged(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Stirrup Specifications
            SectionCard(
              title: 'مواصفات الكانات والأقفال',
              icon: Icons.reorder_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stirrup Diameter
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.stirrupDiameter,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<int>(
                              value: state.stirrupDiameterMm,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              ),
                              items: const [
                                DropdownMenuItem(value: 8, child: Text('Φ 8 مم (القياسي للكمرات والأعمدة)')),
                                DropdownMenuItem(value: 10, child: Text('Φ 10 مم (أعمدة وكمرات ثقيلة)')),
                                DropdownMenuItem(value: 12, child: Text('Φ 12 مم (قواعد وأحمال خاصة)')),
                              ],
                              onChanged: (newDiam) {
                                if (newDiam != null) {
                                  HapticService.selection();
                                  ref.read(stirrupsProvider.notifier).updateInputs(stirrupDiameterMm: newDiam);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Hook type
                  DropdownButtonFormField<StirrupHookType>(
                    value: state.hookType,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: StirrupHookType.values.map((h) {
                      return DropdownMenuItem(
                        value: h,
                        child: Text(h.nameArabic, style: const TextStyle(fontSize: 12.5)),
                      );
                    }).toList(),
                    onChanged: (newHook) {
                      if (newHook != null) {
                        HapticService.selection();
                        ref.read(stirrupsProvider.notifier).updateInputs(hookType: newHook);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  // Spacing
                  CustomTextField(
                    controller: _spacingController,
                    label: AppStrings.stirrupSpacing,
                    hint: '15',
                    suffixUnit: AppStrings.unitCm,
                    prefixIcon: Icons.space_bar_rounded,
                    validator: Validators.positiveDouble,
                    onChanged: (_) => _onInputsChanged(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Results Card
            if (result != null) ...[
              ResultCard(
                title: 'نتائج حصر الكانات والأساور',
                headerIcon: Icons.border_all_rounded,
                items: [
                  ResultItem(
                    label: AppStrings.stirrupCutLength,
                    value: NumberFormatter.format(result.cutLengthPerStirrupM),
                    unit: AppStrings.unitM,
                    subtitle: 'طول السيخ المفرد قبل التشكيل شاملاً أقفال التماسك',
                    icon: Icons.straighten_rounded,
                  ),
                  ResultItem(
                    label: AppStrings.totalStirrupCount,
                    value: '${result.totalStirrupCount}',
                    unit: 'كانة',
                    subtitle: 'توزيع كل ${state.spacingCm} سم على طول ${state.memberLengthM} م',
                    isHighlight: true,
                    icon: Icons.tag_rounded,
                  ),
                  ResultItem(
                    label: 'إجمالي أطوال حديد الكانات',
                    value: NumberFormatter.format(result.totalSteelLengthM),
                    unit: AppStrings.unitM,
                    icon: Icons.linear_scale_rounded,
                  ),
                  ResultItem(
                    label: AppStrings.totalStirrupWeight,
                    value: NumberFormatter.format(result.totalWeightKg),
                    unit: AppStrings.unitKg,
                    subtitle: 'ما يعادل ${NumberFormatter.format(result.totalWeightTon, maxDecimals: 3)} طن',
                    isHighlight: true,
                    icon: Icons.scale_rounded,
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
