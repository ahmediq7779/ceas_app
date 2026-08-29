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
import '../../../models/steel_rebar_model.dart';
import '../../../providers/steel_calculator_provider.dart';

class LapSpliceTab extends ConsumerStatefulWidget {
  const LapSpliceTab({Key? key}) : super(key: key);

  @override
  ConsumerState<LapSpliceTab> createState() => _LapSpliceTabState();
}

class _LapSpliceTabState extends ConsumerState<LapSpliceTab> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fcController;
  late TextEditingController _fyController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(lapSpliceProvider);
    _fcController = TextEditingController(text: state.fcMpa.toString());
    _fyController = TextEditingController(text: state.fyMpa.toString());
  }

  @override
  void dispose() {
    _fcController.dispose();
    _fyController.dispose();
    super.dispose();
  }

  void _onInputsChanged() {
    ref.read(lapSpliceProvider.notifier).updateInputs(
      fcMpa: NumberFormatter.parseDouble(_fcController.text, defaultValue: 25.0),
      fyMpa: NumberFormatter.parseDouble(_fyController.text, defaultValue: 420.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lapSpliceProvider);
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
            // Rebar Diameter Selector
            SectionCard(
              title: AppStrings.rebarDiameter,
              icon: Icons.lens_blur_rounded,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: RebarDiameters.standard.map((d) {
                  final isSelected = state.diameterMm == d;
                  return InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      HapticService.selection();
                      ref.read(lapSpliceProvider.notifier).updateInputs(diameterMm: d);
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
            ),
            const SizedBox(height: 16),

            // Material Properties
            SectionCard(
              title: 'خواص المواد الإنشائية (Material Strengths)',
              icon: Icons.biotech_outlined,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _fcController,
                          label: AppStrings.concreteStrength,
                          hint: '25',
                          suffixUnit: 'MPa',
                          validator: Validators.positiveDouble,
                          onChanged: (_) => _onInputsChanged(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _fyController,
                          label: AppStrings.steelYield,
                          hint: '420',
                          suffixUnit: 'MPa',
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

            // Splice Type and Modifiers
            SectionCard(
              title: AppStrings.spliceType,
              icon: Icons.link_rounded,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<SpliceType>(
                    value: state.spliceType,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    items: SpliceType.values.map((st) {
                      return DropdownMenuItem(
                        value: st,
                        child: Text(
                          st.nameArabic,
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                        ),
                      );
                    }).toList(),
                    onChanged: (newType) {
                      if (newType != null) {
                        HapticService.selection();
                        ref.read(lapSpliceProvider.notifier).updateInputs(spliceType: newType);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  // Modifiers Switches
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.primaryOrange,
                    title: Text(
                      AppStrings.topBarFactor,
                      style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'معامل صب الخرسانة الطازجة أسفل السيخ > 30 سم (ψt = 1.3)',
                      style: AppStyles.bodySmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    value: state.isTopBar,
                    onChanged: (val) {
                      HapticService.selection();
                      ref.read(lapSpliceProvider.notifier).updateInputs(isTopBar: val);
                    },
                  ),
                  const Divider(),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.primaryOrange,
                    title: Text(
                      AppStrings.epoxyFactor,
                      style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'حديد مدهون بإيبوكسي مقاوم للصدأ (ψe = 1.2)',
                      style: AppStyles.bodySmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    value: state.isEpoxyCoated,
                    onChanged: (val) {
                      HapticService.selection();
                      ref.read(lapSpliceProvider.notifier).updateInputs(isEpoxyCoated: val);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Results Card
            if (result != null) ...[
              ResultCard(
                title: 'نتائج حساب طول التراكب والتماسك',
                headerIcon: Icons.compare_arrows_rounded,
                items: [
                  ResultItem(
                    label: AppStrings.devLength,
                    value: NumberFormatter.format(result.developmentLengthCm, maxDecimals: 1),
                    unit: AppStrings.unitCm,
                    subtitle: 'المسافة اللازمة لتطوير كامل إجهاد الخضوع للسيخ داخل الخرسانة',
                    icon: Icons.straighten_rounded,
                  ),
                  ResultItem(
                    label: AppStrings.lapLength,
                    value: NumberFormatter.format(result.lapSpliceLengthCm, maxDecimals: 1),
                    unit: AppStrings.unitCm,
                    subtitle: 'ما يعادل ${NumberFormatter.format(result.lapSpliceLengthM, maxDecimals: 2)} متر',
                    isHighlight: true,
                    icon: Icons.arrow_right_alt_rounded,
                  ),
                  ResultItem(
                    label: AppStrings.barMultiple,
                    value: '${NumberFormatter.format(result.barDiameterMultiplier, maxDecimals: 1)} Φ',
                    unit: 'ضعف القطر',
                    subtitle: 'طول الوصلة المطلوب مقسوماً على قطر السيخ Φ${state.diameterMm}',
                    icon: Icons.repeat_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.steelBlue.withOpacity(0.1),
                  borderRadius: AppStyles.radiusSmall,
                  border: Border.all(
                    color: AppColors.steelBlue.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: AppColors.steelBlueLight,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        result.engineeringNote,
                        style: AppStyles.bodySmall.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
