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
import '../../../models/formwork_earthwork_model.dart';
import '../../../providers/boq_provider.dart';
import '../../../providers/formwork_calculator_provider.dart';
import '../../../providers/rate_settings_provider.dart';

class FormworkContactTab extends ConsumerStatefulWidget {
  const FormworkContactTab({Key? key}) : super(key: key);

  @override
  ConsumerState<FormworkContactTab> createState() => _FormworkContactTabState();
}

class _FormworkContactTabState extends ConsumerState<FormworkContactTab> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _lengthController;
  late TextEditingController _widthController;
  late TextEditingController _heightController;
  late TextEditingController _countController;
  late TextEditingController _reuseController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(formworkProvider);
    _lengthController = TextEditingController(text: state.lengthM.toString());
    _widthController = TextEditingController(text: state.widthM.toString());
    _heightController = TextEditingController(text: state.heightOrDepthM.toString());
    _countController = TextEditingController(text: state.count.toString());
    _reuseController = TextEditingController(text: state.reuseCycles.toString());
  }

  @override
  void dispose() {
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _countController.dispose();
    _reuseController.dispose();
    super.dispose();
  }

  void _onInputsChanged() {
    ref.read(formworkProvider.notifier).updateInputs(
      lengthM: NumberFormatter.parseDouble(_lengthController.text, defaultValue: 1.0),
      widthM: NumberFormatter.parseDouble(_widthController.text, defaultValue: 1.0),
      heightOrDepthM: NumberFormatter.parseDouble(_heightController.text, defaultValue: 0.20),
      count: NumberFormatter.parseInt(_countController.text, defaultValue: 1),
      reuseCycles: NumberFormatter.parseInt(_reuseController.text, defaultValue: 1),
    );
  }

  void _addToBoq() {
    final state = ref.read(formworkProvider);
    final rates = ref.read(rateSettingsProvider);
    final res = state.result;
    if (res == null || res.contactAreaM2 <= 0) return;

    final item = BoqItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: BoqCategory.formwork,
      title: 'شدات خشبية وقوالب (${state.elementType.nameArabic.split(' ').first})',
      description: 'أعمال شدات خشبية وقوالب صب بمساحة ملامسة إجمالية ${NumberFormatter.format(res.contactAreaM2)} م² (تتطلب ${NumberFormatter.format(res.netPlywoodSheetsPurchased, maxDecimals: 0)} لوح خشب بلايوود بمعدل تكرار ${state.reuseCycles} مرات)',
      unit: AppStrings.unitM2,
      quantity: res.contactAreaM2,
      unitPrice: rates.formworkPricePerM2,
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
    final state = ref.watch(formworkProvider);
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
            // Element Type Selection
            SectionCard(
              title: AppStrings.elementCategory,
              icon: Icons.category_outlined,
              child: DropdownButtonFormField<FormworkElementType>(
                value: state.elementType,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                items: FormworkElementType.values.map((t) {
                  return DropdownMenuItem(
                    value: t,
                    child: Text(t.nameArabic, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  );
                }).toList(),
                onChanged: (newType) {
                  if (newType != null) {
                    HapticService.selection();
                    ref.read(formworkProvider.notifier).updateElementType(newType);
                  }
                },
              ),
            ),
            const SizedBox(height: 16),

            // Dimensions Section
            SectionCard(
              title: 'أبعاد العنصر والعدد',
              icon: Icons.straighten_rounded,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _lengthController,
                          label: AppStrings.length,
                          hint: '12.0',
                          suffixUnit: AppStrings.unitM,
                          validator: Validators.positiveDouble,
                          onChanged: (_) => _onInputsChanged(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _widthController,
                          label: AppStrings.width,
                          hint: '8.0',
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
                          controller: _heightController,
                          label: AppStrings.heightOrDepth,
                          hint: '0.20',
                          suffixUnit: AppStrings.unitM,
                          validator: Validators.positiveDouble,
                          onChanged: (_) => _onInputsChanged(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _countController,
                          label: AppStrings.countOrRepeats,
                          hint: '1',
                          suffixUnit: 'عناصر',
                          validator: Validators.positiveInt,
                          onChanged: (_) => _onInputsChanged(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _reuseController,
                    label: AppStrings.formworkReuse,
                    hint: '4',
                    suffixUnit: 'مرات',
                    prefixIcon: Icons.replay_rounded,
                    validator: Validators.positiveInt,
                    onChanged: (_) => _onInputsChanged(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Results Card
            if (result != null) ...[
              ResultCard(
                title: 'نتائج حساب مساحة الشدات وألواح الخشب',
                headerIcon: Icons.table_chart_outlined,
                items: [
                  ResultItem(
                    label: AppStrings.totalContactArea,
                    value: NumberFormatter.format(result.contactAreaM2),
                    unit: AppStrings.unitM2,
                    subtitle: 'إجمالي مساحة الخرسانة الملامسة لقوالب الشدة',
                    isHighlight: true,
                    icon: Icons.aspect_ratio_rounded,
                  ),
                  ResultItem(
                    label: 'إجمالي ألواح الخشب المطلوبة (1.22×2.44م)',
                    value: NumberFormatter.format(result.plywoodSheetsNeeded, maxDecimals: 1),
                    unit: AppStrings.unitSheets,
                    subtitle: 'المساحة الكلية مقسومة على مساحة اللوح القياسي (2.98 م²)',
                    icon: Icons.layers_outlined,
                  ),
                  ResultItem(
                    label: 'صافي الألواح الواجب شراؤها (بعد التكرار)',
                    value: NumberFormatter.format(result.netPlywoodSheetsPurchased, maxDecimals: 0),
                    unit: AppStrings.unitSheets,
                    subtitle: 'على أساس إعادة استخدام الخشب بمعدل ${state.reuseCycles} دورات صب',
                    isHighlight: true,
                    icon: Icons.shopping_bag_outlined,
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
