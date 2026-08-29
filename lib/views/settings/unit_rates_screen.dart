import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_styles.dart';
import '../../core/utils/haptic_service.dart';
import '../../core/utils/number_formatter.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_button.dart';
import '../../models/rate_settings_model.dart';
import '../../providers/rate_settings_provider.dart';
import 'widgets/rate_input_tile.dart';

class UnitRatesScreen extends ConsumerStatefulWidget {
  const UnitRatesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<UnitRatesScreen> createState() => _UnitRatesScreenState();
}

class _UnitRatesScreenState extends ConsumerState<UnitRatesScreen> {
  late TextEditingController _currencyController;
  late TextEditingController _cementController;
  late TextEditingController _sandController;
  late TextEditingController _gravelController;
  late TextEditingController _readyMixController;
  late TextEditingController _blockController;
  late TextEditingController _rebarController;
  late TextEditingController _formworkController;
  late TextEditingController _excavationController;
  late TextEditingController _backfillController;

  @override
  void initState() {
    super.initState();
    final rates = ref.read(rateSettingsProvider);
    _currencyController = TextEditingController(text: rates.currency);
    _cementController = TextEditingController(text: rates.cementBagPrice.toString());
    _sandController = TextEditingController(text: rates.sandPricePerM3.toString());
    _gravelController = TextEditingController(text: rates.gravelPricePerM3.toString());
    _readyMixController = TextEditingController(text: rates.readyMixConcretePerM3.toString());
    _blockController = TextEditingController(text: rates.blockPricePerThousand.toString());
    _rebarController = TextEditingController(text: rates.rebarPricePerTon.toString());
    _formworkController = TextEditingController(text: rates.formworkPricePerM2.toString());
    _excavationController = TextEditingController(text: rates.excavationPricePerM3.toString());
    _backfillController = TextEditingController(text: rates.backfillPricePerM3.toString());
  }

  @override
  void dispose() {
    _currencyController.dispose();
    _cementController.dispose();
    _sandController.dispose();
    _gravelController.dispose();
    _readyMixController.dispose();
    _blockController.dispose();
    _rebarController.dispose();
    _formworkController.dispose();
    _excavationController.dispose();
    _backfillController.dispose();
    super.dispose();
  }

  void _saveRates() {
    final newRates = RateSettingsModel(
      currency: _currencyController.text.trim().isNotEmpty ? _currencyController.text.trim() : 'SAR',
      cementBagPrice: NumberFormatter.parseDouble(_cementController.text, defaultValue: 25.0),
      sandPricePerM3: NumberFormatter.parseDouble(_sandController.text, defaultValue: 35.0),
      gravelPricePerM3: NumberFormatter.parseDouble(_gravelController.text, defaultValue: 45.0),
      readyMixConcretePerM3: NumberFormatter.parseDouble(_readyMixController.text, defaultValue: 240.0),
      blockPricePerThousand: NumberFormatter.parseDouble(_blockController.text, defaultValue: 2200.0),
      rebarPricePerTon: NumberFormatter.parseDouble(_rebarController.text, defaultValue: 3100.0),
      formworkPricePerM2: NumberFormatter.parseDouble(_formworkController.text, defaultValue: 40.0),
      excavationPricePerM3: NumberFormatter.parseDouble(_excavationController.text, defaultValue: 18.0),
      backfillPricePerM3: NumberFormatter.parseDouble(_backfillController.text, defaultValue: 25.0),
    );

    ref.read(rateSettingsProvider.notifier).updateRates(newRates);
    HapticService.success();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(AppStrings.ratesSavedSuccessfully),
          ],
        ),
        backgroundColor: AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _resetDefaults() {
    ref.read(rateSettingsProvider.notifier).resetToDefaults();
    final rates = ref.read(rateSettingsProvider);
    _currencyController.text = rates.currency;
    _cementController.text = rates.cementBagPrice.toString();
    _sandController.text = rates.sandPricePerM3.toString();
    _gravelController.text = rates.gravelPricePerM3.toString();
    _readyMixController.text = rates.readyMixConcretePerM3.toString();
    _blockController.text = rates.blockPricePerThousand.toString();
    _rebarController.text = rates.rebarPricePerTon.toString();
    _formworkController.text = rates.formworkPricePerM2.toString();
    _excavationController.text = rates.excavationPricePerM3.toString();
    _backfillController.text = rates.backfillPricePerM3.toString();
    HapticService.warning();
  }

  @override
  Widget build(BuildContext context) {
    final rates = ref.watch(rateSettingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.ratesSettingsTitle,
        subtitle: AppStrings.ratesSettingsSubtitle,
        actions: [
          IconButton(
            tooltip: 'استعادة الأسعار الافتراضية',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _resetDefaults,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Currency Selector Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSlate800 : AppColors.lightSurface,
                borderRadius: AppStyles.radiusMedium,
                border: Border.all(
                  color: AppColors.primaryOrange.withOpacity(0.4),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.currency_exchange_rounded, color: AppColors.primaryOrange, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'رمز العملة المعتمدة بالمشروع',
                          style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'مثال: SAR, EGP, AED, USD, IQD, JOD',
                          style: AppStyles.bodySmall.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: _currencyController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primaryOrange),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'قائمة أسعار الخامات والمصنعيات الإنشائية',
              style: AppStyles.heading3.copyWith(fontSize: 15),
            ),
            const SizedBox(height: 12),

            // Material Rate Inputs
            RateInputTile(
              title: AppStrings.cementBagPrice,
              subtitle: 'سعر شيكارة الأسمنت البورتلاندي العادي 50 كجم',
              controller: _cementController,
              unit: AppStrings.unitBags,
              currency: rates.currency,
              icon: Icons.inventory_2_outlined,
            ),
            RateInputTile(
              title: AppStrings.sandPrice,
              subtitle: 'سعر متر الرمل الصافي النظيف المورد للموقع',
              controller: _sandController,
              unit: AppStrings.unitM3,
              currency: rates.currency,
              icon: Icons.grain_rounded,
            ),
            RateInputTile(
              title: AppStrings.gravelPrice,
              subtitle: 'سعر متر الحصى/الزلط/السن المتدرج',
              controller: _gravelController,
              unit: AppStrings.unitM3,
              currency: rates.currency,
              icon: Icons.scatter_plot_rounded,
            ),
            RateInputTile(
              title: AppStrings.readyMixPrice,
              subtitle: 'سعر توريد وصب متر الخرسانة الجاهزة بالمضخة',
              controller: _readyMixController,
              unit: AppStrings.unitM3,
              currency: rates.currency,
              icon: Icons.domain_rounded,
            ),
            RateInputTile(
              title: AppStrings.blockThousandPrice,
              subtitle: 'سعر الألف طوبة/بلوكة خرسانية مفرغة توريد الموقع',
              controller: _blockController,
              unit: '1000 بلوكة',
              currency: rates.currency,
              icon: Icons.view_comfy_rounded,
            ),
            RateInputTile(
              title: AppStrings.steelTonPrice,
              subtitle: 'سعر طن حديد التسليح عالي المقاومة (Grade 60)',
              controller: _rebarController,
              unit: AppStrings.unitTon,
              currency: rates.currency,
              icon: Icons.fitness_center_rounded,
            ),
            RateInputTile(
              title: AppStrings.formworkM2Price,
              subtitle: 'سعر متر مسطح الشدات الخشبية والقوالب',
              controller: _formworkController,
              unit: AppStrings.unitM2,
              currency: rates.currency,
              icon: Icons.square_foot_rounded,
            ),
            RateInputTile(
              title: AppStrings.excavationM3Price,
              subtitle: 'سعر متر مكعب الحفر ونقل ناتج الحفر للمقالب',
              controller: _excavationController,
              unit: AppStrings.unitM3,
              currency: rates.currency,
              icon: Icons.landslide_outlined,
            ),
            RateInputTile(
              title: AppStrings.backfillM3Price,
              subtitle: 'سعر متر مكعب توريد الردم النظيف مع الرش والدمك',
              controller: _backfillController,
              unit: AppStrings.unitM3,
              currency: rates.currency,
              icon: Icons.compress_rounded,
            ),
            const SizedBox(height: 20),

            // Save Button
            CustomButton(
              text: AppStrings.saveChanges,
              icon: Icons.save_rounded,
              onPressed: _saveRates,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
