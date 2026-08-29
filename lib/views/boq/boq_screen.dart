import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_styles.dart';
import '../../core/utils/haptic_service.dart';
import '../../core/widgets/custom_app_bar.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/empty_state_view.dart';
import '../../models/boq_item_model.dart';
import '../../providers/boq_provider.dart';
import '../../providers/rate_settings_provider.dart';
import '../../services/pdf_report_service.dart';
import 'widgets/boq_item_card.dart';
import 'widgets/boq_summary_card.dart';
import 'project_details_dialog.dart';

class BoqScreen extends ConsumerStatefulWidget {
  const BoqScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<BoqScreen> createState() => _BoqScreenState();
}

class _BoqScreenState extends ConsumerState<BoqScreen> {
  BoqCategory? _selectedCategory;
  bool _isGeneratingPdf = false;

  void _showClearAllConfirm() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(ctx).cardTheme.color,
          shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusMedium),
          title: const Text('تفريغ جدول الكميات'),
          content: const Text('هل أنت متأكد من رغبتك في حذف جميع البنود المسجلة؟ لا يمكن التراجع عن هذا الإجراء.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
              onPressed: () {
                ref.read(boqProvider.notifier).clearAll();
                HapticService.warning();
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(AppStrings.boqCleared),
                    backgroundColor: AppColors.errorRed,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('مسح الكل'),
            ),
          ],
        );
      },
    );
  }

  void _openProjectDialog() {
    final items = ref.read(boqProvider);
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا توجد بنود في جدول الكميات لتصدير التقرير'),
          backgroundColor: AppColors.warningAmber,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return ProjectDetailsDialog(
          onConfirm: (metadata, isShare) => _processPdf(metadata, isShare),
        );
      },
    );
  }

  Future<void> _processPdf(ProjectMetadata metadata, bool isShare) async {
    setState(() => _isGeneratingPdf = true);
    final items = ref.read(boqProvider);
    final rates = ref.read(rateSettingsProvider);

    try {
      if (isShare) {
        await PdfReportService.shareReport(
          items: items,
          metadata: metadata,
          currency: rates.currency,
        );
      } else {
        await PdfReportService.printReport(
          items: items,
          metadata: metadata,
          currency: rates.currency,
        );
      }
      HapticService.success();
    } catch (e) {
      HapticService.warning();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppStrings.pdfError}: ${e.toString()}'),
            backgroundColor: AppColors.errorRed,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPdf = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allItems = ref.watch(boqProvider);
    final totalCost = ref.watch(boqTotalCostProvider);
    final rates = ref.watch(rateSettingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredItems = _selectedCategory == null
        ? allItems
        : allItems.where((item) => item.category == _selectedCategory).toList();

    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.boqModule,
        subtitle: 'حصر الكميات الشامل وإصدار تقارير PDF المعتمدة',
        actions: [
          if (allItems.isNotEmpty)
            IconButton(
              tooltip: AppStrings.clearAll,
              icon: const Icon(Icons.delete_sweep_outlined, color: AppColors.errorRed),
              onPressed: _showClearAllConfirm,
            ),
        ],
      ),
      body: allItems.isEmpty
          ? EmptyStateView(
              icon: Icons.receipt_long_outlined,
              title: AppStrings.boqEmpty,
              description: AppStrings.boqEmptyDesc,
              action: CustomButton(
                text: 'العودة للرئيسية وإجراء الحسابات',
                icon: Icons.calculate_outlined,
                isFullWidth: false,
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : Column(
              children: [
                // Top Summary & Filter
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    children: [
                      BoqSummaryCard(
                        totalAmount: totalCost,
                        totalItems: allItems.length,
                        currency: rates.currency,
                      ),
                      const SizedBox(height: 12),

                      // Category Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: [
                            ChoiceChip(
                              label: const Text('الكل'),
                              selected: _selectedCategory == null,
                              onSelected: (_) {
                                HapticService.selection();
                                setState(() => _selectedCategory = null);
                              },
                            ),
                            const SizedBox(width: 6),
                            ...BoqCategory.values.map((cat) {
                              final isSelected = _selectedCategory == cat;
                              return Padding(
                                padding: const EdgeInsetsDirectional.only(end: 6),
                                child: ChoiceChip(
                                  label: Text(cat.shortName),
                                  selected: isSelected,
                                  onSelected: (_) {
                                    HapticService.selection();
                                    setState(() => _selectedCategory = cat);
                                  },
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Items List
                Expanded(
                  child: filteredItems.isEmpty
                      ? Center(
                          child: Text(
                            'لا توجد بنود في هذا القسم',
                            style: AppStyles.bodyMedium.copyWith(
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: filteredItems.length,
                          itemBuilder: (ctx, index) {
                            final item = filteredItems[index];
                            return BoqItemCard(
                              item: item,
                              currency: rates.currency,
                              onDelete: () {
                                ref.read(boqProvider.notifier).deleteItem(item.id);
                              },
                              onEdit: (newQty, newPrice) {
                                final updated = item.copyWith(
                                  quantity: newQty,
                                  unitPrice: newPrice,
                                );
                                ref.read(boqProvider.notifier).updateItem(updated);
                              },
                            );
                          },
                        ),
                ),

                // Bottom Export Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSlate900 : AppColors.lightSurface,
                    border: Border(
                      top: BorderSide(
                        color: isDark ? AppColors.darkSlate700 : AppColors.lightBorder,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: CustomButton(
                      text: AppStrings.generateReport,
                      icon: Icons.picture_as_pdf_rounded,
                      isLoading: _isGeneratingPdf,
                      onPressed: _openProjectDialog,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
