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
import '../../../core/widgets/unit_selector.dart';
import '../../../models/boq_item_model.dart';
import '../../../models/concrete_mix_model.dart';
import '../../../providers/boq_provider.dart';
import '../../../providers/concrete_calculator_provider.dart';
import '../../../providers/rate_settings_provider.dart';

class ConcreteMixTab extends ConsumerStatefulWidget {
  const ConcreteMixTab({Key? key}) : super(key: key);

  @override
  ConsumerState<ConcreteMixTab> createState() => _ConcreteMixTabState();
}

class _ConcreteMixTabState extends ConsumerState<ConcreteMixTab> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _lengthController;
  late TextEditingController _widthController;
  late TextEditingController _heightController;
  late TextEditingController _diameterController;
  late TextEditingController _repeatsController;
  late TextEditingController _directVolumeController;

  late TextEditingController _cementRatioController;
  late TextEditingController _sandRatioController;
  late TextEditingController _gravelRatioController;
  late TextEditingController _wcRatioController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(concreteMixProvider);
    _lengthController = TextEditingController(text: state.lengthM.toString());
    _widthController = TextEditingController(text: state.widthM.toString());
    _heightController = TextEditingController(text: state.heightOrDepthM.toString());
    _diameterController = TextEditingController(text: state.diameterM.toString());
    _repeatsController = TextEditingController(text: state.repeatsCount.toString());
    _directVolumeController = TextEditingController(text: state.directVolumeM3.toString());

    _cementRatioController = TextEditingController(text: state.cementRatio.toString());
    _sandRatioController = TextEditingController(text: state.sandRatio.toString());
    _gravelRatioController = TextEditingController(text: state.gravelRatio.toString());
    _wcRatioController = TextEditingController(text: state.waterCementRatio.toString());
  }

  @override
  void dispose() {
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _diameterController.dispose();
    _repeatsController.dispose();
    _directVolumeController.dispose();
    _cementRatioController.dispose();
    _sandRatioController.dispose();
    _gravelRatioController.dispose();
    _wcRatioController.dispose();
    super.dispose();
  }

  void _onDimensionsChanged() {
    ref.read(concreteMixProvider.notifier).updateDimensions(
      lengthM: NumberFormatter.parseDouble(_lengthController.text, defaultValue: 1.0),
      widthM: NumberFormatter.parseDouble(_widthController.text, defaultValue: 1.0),
      heightOrDepthM: NumberFormatter.parseDouble(_heightController.text, defaultValue: 0.2),
      diameterM: NumberFormatter.parseDouble(_diameterController.text, defaultValue: 0.5),
      repeatsCount: NumberFormatter.parseInt(_repeatsController.text, defaultValue: 1),
      directVolumeM3: NumberFormatter.parseDouble(_directVolumeController.text, defaultValue: 1.0),
    );
  }

  void _onRatiosChanged() {
    ref.read(concreteMixProvider.notifier).updateRatios(
      cementRatio: NumberFormatter.parseDouble(_cementRatioController.text, defaultValue: 1.0),
      sandRatio: NumberFormatter.parseDouble(_sandRatioController.text, defaultValue: 1.5),
      gravelRatio: NumberFormatter.parseDouble(_gravelRatioController.text, defaultValue: 3.0),
      waterCementRatio: NumberFormatter.parseDouble(_wcRatioController.text, defaultValue: 0.50),
    );
  }

  void _addToBoq() {
    final state = ref.read(concreteMixProvider);
    final rates = ref.read(rateSettingsProvider);
    final res = state.result;
    if (res == null || res.wetVolumeM3 <= 0) return;

    final item = BoqItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: BoqCategory.concrete,
      title: 'خرسانة مسلحة (${state.preset.nameArabic.split(' ').first})',
      description: 'صب وتوريد خرسانة بحجم ${NumberFormatter.format(res.wetVolumeM3)} م³ (أسمنت: ${NumberFormatter.format(res.cementBags50kg, maxDecimals: 0)} كيس، رمل: ${NumberFormatter.format(res.sandVolumeM3)} م³، زلط: ${NumberFormatter.format(res.gravelVolumeM3)} م³)',
      unit: AppStrings.unitM3,
      quantity: res.wetVolumeM3,
      unitPrice: rates.readyMixConcretePerM3 > 0
          ? rates.readyMixConcretePerM3
          : (res.estimatedCost / res.wetVolumeM3),
      totalPrice: (rates.readyMixConcretePerM3 > 0
              ? rates.readyMixConcretePerM3
              : (res.estimatedCost / res.wetVolumeM3)) *
          res.wetVolumeM3,
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
    final state = ref.watch(concreteMixProvider);
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
            // Element Shape Selector
            SectionCard(
              title: AppStrings.concreteShape,
              icon: Icons.category_outlined,
              child: CustomSegmentedControl<ConcreteShape>(
                selectedValue: state.shape,
                items: const [
                  SegmentItem(
                    value: ConcreteShape.slabOrFooting,
                    label: 'بلاطة / قاعدة',
                    icon: Icons.crop_din_rounded,
                  ),
                  SegmentItem(
                    value: ConcreteShape.rectangularColumn,
                    label: 'عمود / كمرة',
                    icon: Icons.view_agenda_outlined,
                  ),
                  SegmentItem(
                    value: ConcreteShape.circularColumn,
                    label: 'دائري / خازوق',
                    icon: Icons.radio_button_unchecked_rounded,
                  ),
                  SegmentItem(
                    value: ConcreteShape.directVolume,
                    label: 'حجم مباشر',
                    icon: Icons.all_inclusive_rounded,
                  ),
                ],
                onSelected: (shape) {
                  ref.read(concreteMixProvider.notifier).updateShape(shape);
                },
              ),
            ),
            const SizedBox(height: 16),

            // Dimensions Section
            SectionCard(
              title: 'الأبعاد والمقاسات الإنشائية',
              icon: Icons.straighten_rounded,
              child: Column(
                children: [
                  if (state.shape == ConcreteShape.directVolume) ...[
                    CustomTextField(
                      controller: _directVolumeController,
                      label: 'الحجم الإجمالي للخرسانة المطلوبة',
                      hint: 'مثال: 15.5',
                      suffixUnit: AppStrings.unitM3,
                      prefixIcon: Icons.space_dashboard_outlined,
                      validator: Validators.positiveDouble,
                      onChanged: (_) => _onDimensionsChanged(),
                    ),
                  ] else if (state.shape == ConcreteShape.circularColumn) ...[
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _diameterController,
                            label: 'قطر العمود (D)',
                            hint: '0.50',
                            suffixUnit: AppStrings.unitM,
                            prefixIcon: Icons.circle_outlined,
                            validator: Validators.positiveDouble,
                            onChanged: (_) => _onDimensionsChanged(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            controller: _heightController,
                            label: 'الارتفاع (H)',
                            hint: '3.00',
                            suffixUnit: AppStrings.unitM,
                            prefixIcon: Icons.height_rounded,
                            validator: Validators.positiveDouble,
                            onChanged: (_) => _onDimensionsChanged(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _repeatsController,
                      label: 'عدد الأعمدة المتماثلة',
                      hint: '1',
                      suffixUnit: 'أعمدة',
                      prefixIcon: Icons.numbers_rounded,
                      validator: Validators.positiveInt,
                      onChanged: (_) => _onDimensionsChanged(),
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _lengthController,
                            label: 'الطول (L)',
                            hint: '10.0',
                            suffixUnit: AppStrings.unitM,
                            validator: Validators.positiveDouble,
                            onChanged: (_) => _onDimensionsChanged(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            controller: _widthController,
                            label: 'العرض (W)',
                            hint: '5.0',
                            suffixUnit: AppStrings.unitM,
                            validator: Validators.positiveDouble,
                            onChanged: (_) => _onDimensionsChanged(),
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
                            label: state.shape == ConcreteShape.slabOrFooting
                                ? 'السمك / العمق (T)'
                                : 'الارتفاع (H)',
                            hint: '0.20',
                            suffixUnit: AppStrings.unitM,
                            validator: Validators.positiveDouble,
                            onChanged: (_) => _onDimensionsChanged(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            controller: _repeatsController,
                            label: 'مرات التكرار / العدد',
                            hint: '1',
                            suffixUnit: 'مرات',
                            validator: Validators.positiveInt,
                            onChanged: (_) => _onDimensionsChanged(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Mix Design Preset Selector
            SectionCard(
              title: AppStrings.mixRatio,
              icon: Icons.tune_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<ConcreteMixPreset>(
                    value: state.preset,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    items: ConcreteMixPreset.values.map((p) {
                      return DropdownMenuItem(
                        value: p,
                        child: Text(
                          p.nameArabic,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      );
                    }).toList(),
                    onChanged: (newPreset) {
                      if (newPreset != null) {
                        ref.read(concreteMixProvider.notifier).updatePreset(newPreset);
                        _cementRatioController.text = newPreset.cementRatio.toString();
                        _sandRatioController.text = newPreset.sandRatio.toString();
                        _gravelRatioController.text = newPreset.gravelRatio.toString();
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  // Ratio fields
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _cementRatioController,
                          label: 'الأسمنت',
                          hint: '1.0',
                          suffixUnit: 'جزء',
                          onChanged: (_) => _onRatiosChanged(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomTextField(
                          controller: _sandRatioController,
                          label: 'الرمل',
                          hint: '1.5',
                          suffixUnit: 'جزء',
                          onChanged: (_) => _onRatiosChanged(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomTextField(
                          controller: _gravelRatioController,
                          label: 'الحصى/الزلط',
                          hint: '3.0',
                          suffixUnit: 'جزء',
                          onChanged: (_) => _onRatiosChanged(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _wcRatioController,
                    label: AppStrings.waterCementRatio,
                    hint: '0.50',
                    suffixUnit: 'W/C',
                    prefixIcon: Icons.water_drop_outlined,
                    onChanged: (_) => _onRatiosChanged(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Calculation Results Card
            if (result != null) ...[
              ResultCard(
                title: AppStrings.resultsConcrete,
                headerIcon: Icons.domain_rounded,
                items: [
                  ResultItem(
                    label: AppStrings.totalVolume,
                    value: NumberFormatter.format(result.wetVolumeM3),
                    unit: AppStrings.unitM3,
                    isHighlight: true,
                    icon: Icons.layers_outlined,
                  ),
                  ResultItem(
                    label: 'الحجم الجاف للخلطة (معامل 1.54)',
                    value: NumberFormatter.format(result.dryVolumeM3),
                    unit: AppStrings.unitM3,
                    icon: Icons.compress_rounded,
                  ),
                  ResultItem(
                    label: AppStrings.cementBags,
                    value: NumberFormatter.format(result.cementBags50kg, maxDecimals: 0),
                    unit: AppStrings.unitBags,
                    subtitle: 'الوزن الإجمالي: ${NumberFormatter.format(result.cementKg)} كجم (${NumberFormatter.format(result.cementKg / 1000)} طن)',
                    isHighlight: true,
                    icon: Icons.inventory_2_outlined,
                  ),
                  ResultItem(
                    label: AppStrings.sandVolume,
                    value: NumberFormatter.format(result.sandVolumeM3),
                    unit: AppStrings.unitM3,
                    icon: Icons.grain_rounded,
                  ),
                  ResultItem(
                    label: AppStrings.gravelVolume,
                    value: NumberFormatter.format(result.gravelVolumeM3),
                    unit: AppStrings.unitM3,
                    icon: Icons.scatter_plot_rounded,
                  ),
                  ResultItem(
                    label: AppStrings.waterVolume,
                    value: NumberFormatter.format(result.waterLiters, maxDecimals: 0),
                    unit: 'لتر',
                    icon: Icons.water_drop_outlined,
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
