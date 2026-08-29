import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_styles.dart';
import '../../core/utils/haptic_service.dart';
import '../../core/utils/number_formatter.dart';
import '../../providers/boq_provider.dart';
import '../../providers/rate_settings_provider.dart';
import '../../providers/theme_provider.dart';
import '../concrete/concrete_calculator_screen.dart';
import '../steel/steel_calculator_screen.dart';
import '../formwork_earthwork/formwork_earthwork_screen.dart';
import '../boq/boq_screen.dart';
import '../settings/unit_rates_screen.dart';
import 'widgets/quick_stat_card.dart';
import 'widgets/module_launcher_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final rates = ref.watch(rateSettingsProvider);
    final boqItems = ref.watch(boqProvider);
    final totalBoqCost = ref.watch(boqTotalCostProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.primaryOrange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.architecture_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.appName,
                  style: AppStyles.heading2.copyWith(
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  AppStrings.appFullName,
                  style: AppStyles.bodySmall.copyWith(
                    fontSize: 10,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Theme Toggle
          IconButton(
            tooltip: isDark ? 'الوضع النهاري' : 'الوضع الليلي',
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            onPressed: () {
              HapticService.selection();
              ref.read(isDarkModeProvider.notifier).toggleTheme();
            },
          ),
          // Rates Settings Button
          IconButton(
            tooltip: AppStrings.unitRates,
            icon: const Icon(
              Icons.price_change_outlined,
              color: AppColors.primaryOrange,
            ),
            onPressed: () {
              HapticService.light();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const UnitRatesScreen()),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats Row
            Row(
              children: [
                Expanded(
                  child: QuickStatCard(
                    title: 'إجمالي المقايسة',
                    value: NumberFormatter.formatCurrency(totalBoqCost, symbol: rates.currency),
                    subtitle: '${boqItems.length} بنود مسجلة',
                    icon: Icons.account_balance_wallet_outlined,
                    accentColor: AppColors.successGreen,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    borderRadius: AppStyles.radiusMedium,
                    onTap: () {
                      HapticService.light();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BoqScreen()),
                      );
                    },
                    child: QuickStatCard(
                      title: 'جدول الكميات (BOQ)',
                      value: '${boqItems.length}',
                      subtitle: 'اضغط لعرض وتصدير PDF',
                      icon: Icons.receipt_long_outlined,
                      accentColor: AppColors.primaryOrange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Modules Section Header
            Text(
              'النماذج والحسابات الإنشائية',
              style: AppStyles.heading3.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 12),

            // Module 1: Concrete & Masonry
            ModuleLauncherCard(
              title: AppStrings.concreteModule,
              description: 'تصميم خلطات الخرسانة (C20/C25/C30)، تقدير الأسمنت والرمل والحصى والماء، وحسابات البلوك والمونة مع خصم الفتحات.',
              icon: Icons.view_in_ar_rounded,
              tags: const ['نسب الخلط', 'معامل 1.54', 'البلوك والمباني', 'خصم الفتحات'],
              accentColor: AppColors.primaryOrange,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ConcreteCalculatorScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            // Module 2: Advanced Steel Rebar
            ModuleLauncherCard(
              title: AppStrings.steelModule,
              description: 'حساب أوزان الأسياخ (D²/162)، أطوال التراكب والرباط (ACI 318)، وتصميم الكانات والأساور مع نسب الهالك والتقطيع.',
              icon: Icons.reorder_rounded,
              tags: const ['أوزان الحديد', 'أطوال التراكب Ld/Ls', 'الكانات والأساور', 'أسياخ 12م'],
              accentColor: AppColors.steelBlueLight,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SteelCalculatorScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            // Module 3: Formwork & Earthwork
            ModuleLauncherCard(
              title: AppStrings.formworkModule,
              description: 'مساحات الشدات الخشبية الملامسة وألواح البلايوود، وحسابات الحفر والردم وانتفاش التربة وسعات الشاحنات.',
              icon: Icons.square_foot_rounded,
              tags: const ['مسطح الشدات', 'ألواح البلايوود', 'الحفر والردم', 'انتفاش التربة %'],
              accentColor: AppColors.warningAmber,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const FormworkEarthworkScreen()),
                );
              },
            ),
            const SizedBox(height: 12),

            // Module 4: BOQ & PDF Export
            ModuleLauncherCard(
              title: AppStrings.boqModule,
              description: 'تجميع وحصر كافة البنود في جدول مقايسة موحد، توليد تقارير PDF رسمية واعتمادات هندسية مع ميزة المشاركة الفورية.',
              icon: Icons.picture_as_pdf_outlined,
              tags: ['حصر الكميات', 'تصدير PDF', 'مشاركة فورية', 'تخصيص الأسعار'],
              accentColor: AppColors.successGreen,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BoqScreen()),
                );
              },
            ),
            const SizedBox(height: 24),

            // Technical Engineering Badge Footer
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSlate950 : AppColors.lightCard,
                borderRadius: AppStyles.radiusSmall,
                border: Border.all(
                  color: isDark ? AppColors.darkSlate800 : AppColors.lightBorder,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.verified_outlined,
                    size: 18,
                    color: AppColors.concreteGrey,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'المعادلات متوافقة مع الكود الأمريكي ACI 318 والكود الأوروبي EC2 ومعايير ASTM القياسية.',
                      style: AppStyles.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.concreteGrey
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
