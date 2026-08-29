import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/utils/haptic_service.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/result_card.dart';
import '../../../core/widgets/section_card.dart';
import '../../../models/boq_item_model.dart';
import '../../../models/masonry_model.dart';
import '../../../providers/boq_provider.dart';
import '../../../providers/concrete_calculator_provider.dart';
import '../../../providers/rate_settings_provider.dart';

class MasonryBlockTab extends ConsumerStatefulWidget {
  const MasonryBlockTab({Key? key}) : super(key: key);

  @override
  ConsumerState<MasonryBlockTab> createState() => _MasonryBlockTabState();
}

class _MasonryBlockTabState extends ConsumerState<MasonryBlockTab> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _wallLengthController;
  late TextEditingController _wallHeightController;
  late TextEditingController _mortarThicknessController;
  late TextEditingController _wasteController;

  late TextEditingController _blockLengthController;
  late TextEditingController _blockHeightController;
  late TextEditingController _blockWidthController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(masonryProvider);
    _wallLengthController = TextEditingController(text: state.wallLengthM.toString());
    _wallHeightController = TextEditingController(text: state.wallHeightM.toString());
    _mortarThicknessController = TextEditingController(text: state.mortarThicknessCm.toString());
    _wasteController = TextEditingController(text: state.wastePercentage.toString());

    _blockLengthController = TextEditingController(text: state.blockLengthCm.toString());
    _blockHeightController = TextEditingController(text: state.blockHeightCm.toString());
    _blockWidthController = TextEditingController(text: state.blockWidthCm.toString());
  }

  @override
  void dispose() {
    _wallLengthController.dispose();
    _wallHeightController.dispose();
    _mortarThicknessController.dispose();
    _wasteController.dispose();
    _blockLengthController.dispose();
    _blockHeightController.dispose();
    _blockWidthController.dispose();
    super.dispose();
  }

  void _onDimensionsChanged() {
    ref.read(masonryProvider.notifier).updateDimensions(
      wallLengthM: NumberFormatter.parseDouble(_wallLengthController.text, defaultValue: 10.0),
      wallHeightM: NumberFormatter.parseDouble(_wallHeightController.text, defaultValue: 3.0),
      mortarThicknessCm: NumberFormatter.parseDouble(_mortarThicknessController.text, defaultValue: 1.5),
      wastePercentage: NumberFormatter.parseDouble(_wasteController.text, defaultValue: 5.0),
    );
  }

  void _onCustomBlockChanged() {
    ref.read(masonryProvider.notifier).updateCustomBlockSize(
      lengthCm: NumberFormatter.parseDouble(_blockLengthController.text, defaultValue: 40.0),
      heightCm: NumberFormatter.parseDouble(_blockHeightController.text, defaultValue: 20.0),
      widthCm: NumberFormatter.parseDouble(_blockWidthController.text, defaultValue: 20.0),
    );
  }

  void _showAddOpeningDialog() {
    final titleCtrl = TextEditingController(text: 'نافذة / فتحة');
    final widthCtrl = TextEditingController(text: '1.2');
    final heightCtrl = TextEditingController(text: '1.2');
    final countCtrl = TextEditingController(text: '1');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardTheme.color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إضافة فتحة خصم من مساحة الجدار',
                style: AppStyles.heading3,
              ),
              const SizedBox(height: 14),
              CustomTextField(
                controller: titleCtrl,
                label: 'وصف الفتحة',
                hint: 'مثال: نافذة غرفة النوم',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: widthCtrl,
                      label: 'العرض (W)',
                      suffixUnit: AppStrings.unitM,
                      validator: Validators.positiveDouble,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: heightCtrl,
                      label: 'الارتفاع (H)',
                      suffixUnit: AppStrings.unitM,
                      validator: Validators.positiveDouble,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: countCtrl,
                label: 'العدد',
                suffixUnit: 'فتحات',
                validator: Validators.positiveInt,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'إضافة الفتحة والخصم',
                icon: Icons.add_rounded,
                onPressed: () {
                  final opening = WallOpening(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    label: titleCtrl.text.isNotEmpty ? titleCtrl.text : 'فتحة جدار',
                    widthM: NumberFormatter.parseDouble(widthCtrl.text, defaultValue: 1.0),
                    heightM: NumberFormatter.parseDouble(heightCtrl.text, defaultValue: 1.0),
                    count: NumberFormatter.parseInt(countCtrl.text, defaultValue: 1),
                  );
                  ref.read(masonryProvider.notifier).addOpening(opening);
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addToBoq() {
    final state = ref.read(masonryProvider);
    final rates = ref.read(rateSettingsProvider);
    final res = state.result;
    if (res == null || res.totalBlocksWithWaste <= 0) return;

    final item = BoqItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      category: BoqCategory.masonry,
      title: 'أعمال مباني وبلوك (${state.blockPreset.nameArabic.split(' ').first})',
      description: 'توريد وبناء بلوك لصافي مساحة ${NumberFormatter.format(res.netWallAreaM2)} م² - إجمالي عدد البلوك: ${NumberFormatter.format(res.totalBlocksWithWaste, maxDecimals: 0)} بلوكة مع مونة أسمنتية ${NumberFormatter.format(res.mortarVolumeM3)} م³',
      unit: AppStrings.unitBlocks,
      quantity: res.totalBlocksWithWaste,
      unitPrice: rates.blockPricePerThousand / 1000.0,
      totalPrice: res.totalEstimatedCost,
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
    final state = ref.watch(masonryProvider);
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
            // Wall Dimensions
            SectionCard(
              title: AppStrings.wallDimensions,
              icon: Icons.crop_portrait_rounded,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: _wallLengthController,
                          label: AppStrings.wallLength,
                          hint: '10.0',
                          suffixUnit: AppStrings.unitM,
                          validator: Validators.positiveDouble,
                          onChanged: (_) => _onDimensionsChanged(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _wallHeightController,
                          label: AppStrings.wallHeight,
                          hint: '3.0',
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
                          controller: _mortarThicknessController,
                          label: AppStrings.mortarThickness,
                          hint: '1.5',
                          suffixUnit: AppStrings.unitCm,
                          validator: Validators.positiveDouble,
                          onChanged: (_) => _onDimensionsChanged(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: _wasteController,
                          label: AppStrings.wastePercentage,
                          hint: '5',
                          suffixUnit: '%',
                          validator: Validators.percentage,
                          onChanged: (_) => _onDimensionsChanged(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Block Size Selection
            SectionCard(
              title: AppStrings.blockSize,
              icon: Icons.view_comfy_alt_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<BlockStandardPreset>(
                    value: state.blockPreset,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    items: BlockStandardPreset.values.map((p) {
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
                        ref.read(masonryProvider.notifier).updateBlockPreset(newPreset);
                        _blockLengthController.text = newPreset.lengthCm.toString();
                        _blockHeightController.text = newPreset.heightCm.toString();
                        _blockWidthController.text = newPreset.widthCm.toString();
                      }
                    },
                  ),
                  if (state.blockPreset == BlockStandardPreset.custom) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _blockLengthController,
                            label: 'طول البلوكة (L)',
                            suffixUnit: AppStrings.unitCm,
                            onChanged: (_) => _onCustomBlockChanged(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomTextField(
                            controller: _blockHeightController,
                            label: 'ارتفاع البلوكة (H)',
                            suffixUnit: AppStrings.unitCm,
                            onChanged: (_) => _onCustomBlockChanged(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomTextField(
                            controller: _blockWidthController,
                            label: 'عرض الجدار (W)',
                            suffixUnit: AppStrings.unitCm,
                            onChanged: (_) => _onCustomBlockChanged(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Openings Deductions
            SectionCard(
              title: AppStrings.openingsDeduction,
              icon: Icons.window_outlined,
              trailing: TextButton.icon(
                onPressed: _showAddOpeningDialog,
                icon: const Icon(Icons.add_circle_outline_rounded, size: 16, color: AppColors.primaryOrange),
                label: const Text(
                  'إضافة فتحة',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primaryOrange),
                ),
              ),
              child: state.openings.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'لا توجد فتحات مخصومة (جدار مصمت بالكامل)',
                          style: AppStyles.bodySmall.copyWith(
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: state.openings.map((op) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSlate950 : AppColors.lightCard,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDark ? AppColors.darkSlate700 : AppColors.lightBorder,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.door_front_door_outlined, size: 18, color: AppColors.primaryOrange),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      op.label,
                                      style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      'المقاس: ${op.widthM}م × ${op.heightM}م (عدد: ${op.count}) = ${NumberFormatter.format(op.totalAreaM2)} م²',
                                      style: AppStyles.bodySmall.copyWith(
                                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.errorRed),
                                onPressed: () {
                                  HapticService.warning();
                                  ref.read(masonryProvider.notifier).removeOpening(op.id);
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 20),

            // Results Card
            if (result != null) ...[
              ResultCard(
                title: 'نتائج حصر البلوك والمونة',
                headerIcon: Icons.foundation_rounded,
                items: [
                  ResultItem(
                    label: AppStrings.netWallArea,
                    value: NumberFormatter.format(result.netWallAreaM2),
                    unit: AppStrings.unitM2,
                    subtitle: 'المساحة الإجمالية: ${NumberFormatter.format(result.grossWallAreaM2)} م² - الفتحات: ${NumberFormatter.format(result.deductionsAreaM2)} م²',
                    icon: Icons.aspect_ratio_rounded,
                  ),
                  ResultItem(
                    label: AppStrings.totalBlocksNeeded,
                    value: NumberFormatter.format(result.totalBlocksWithWaste, maxDecimals: 0),
                    unit: AppStrings.unitBlocks,
                    subtitle: 'العدد الصافي: ${NumberFormatter.format(result.netBlockCount, maxDecimals: 0)} + ${state.wastePercentage}% هالك',
                    isHighlight: true,
                    icon: Icons.view_comfy_rounded,
                  ),
                  ResultItem(
                    label: AppStrings.mortarVolume,
                    value: NumberFormatter.format(result.mortarVolumeM3),
                    unit: AppStrings.unitM3,
                    icon: Icons.water_drop_outlined,
                  ),
                  ResultItem(
                    label: AppStrings.mortarCement,
                    value: NumberFormatter.format(result.mortarCementBags, maxDecimals: 0),
                    unit: AppStrings.unitBags,
                    icon: Icons.inventory_2_outlined,
                  ),
                  ResultItem(
                    label: AppStrings.mortarSand,
                    value: NumberFormatter.format(result.mortarSandM3),
                    unit: AppStrings.unitM3,
                    icon: Icons.grain_rounded,
                  ),
                ],
                totalCostText: NumberFormatter.formatCurrency(result.totalEstimatedCost, symbol: rates.currency),
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
