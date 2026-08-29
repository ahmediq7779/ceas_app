import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/utils/haptic_service.dart';
import '../../../core/utils/number_formatter.dart';
import '../../../models/boq_item_model.dart';

class BoqItemCard extends StatelessWidget {
  final BoqItemModel item;
  final String currency;
  final VoidCallback onDelete;
  final void Function(double newQty, double newPrice)? onEdit;

  const BoqItemCard({
    Key? key,
    required this.item,
    required this.currency,
    required this.onDelete,
    this.onEdit,
  }) : super(key: key);

  void _showEditDialog(BuildContext context) {
    final qtyCtrl = TextEditingController(text: item.quantity.toString());
    final priceCtrl = TextEditingController(text: item.unitPrice.toString());

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(ctx).cardTheme.color,
          shape: RoundedRectangleBorder(borderRadius: AppStyles.radiusMedium),
          title: Text(
            'تعديل الكمية والسعر',
            style: AppStyles.heading3,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.title,
                style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: qtyCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'الكمية الجديدة',
                  suffixText: item.unit,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'سعر الوحدة',
                  suffixText: currency,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                final newQty = NumberFormatter.parseDouble(qtyCtrl.text, defaultValue: item.quantity);
                final newPrice = NumberFormatter.parseDouble(priceCtrl.text, defaultValue: item.unitPrice);
                if (onEdit != null) {
                  onEdit!(newQty, newPrice);
                }
                Navigator.of(ctx).pop();
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color categoryColor;
    switch (item.category) {
      case BoqCategory.concrete:
        categoryColor = AppColors.primaryOrange;
        break;
      case BoqCategory.steel:
        categoryColor = AppColors.steelBlueLight;
        break;
      case BoqCategory.masonry:
        categoryColor = AppColors.warningAmber;
        break;
      case BoqCategory.formwork:
        categoryColor = const Color(0xFF8B5CF6);
        break;
      case BoqCategory.earthwork:
        categoryColor = const Color(0xFF10B981);
        break;
      case BoqCategory.other:
        categoryColor = AppColors.concreteGrey;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSlate800 : AppColors.lightSurface,
        borderRadius: AppStyles.radiusMedium,
        border: Border.all(
          color: isDark ? AppColors.darkSlate700 : AppColors.lightBorder,
        ),
        boxShadow: isDark ? AppStyles.cardShadowDark : AppStyles.cardShadowLight,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: category badge + actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: categoryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: categoryColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    item.category.displayName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: categoryColor,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      onPressed: () {
                        HapticService.selection();
                        _showEditDialog(context);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.errorRed),
                      onPressed: () {
                        HapticService.warning();
                        onDelete();
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Item Title
            Text(
              item.title,
              style: AppStyles.heading3.copyWith(
                fontSize: 15,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            if (item.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                item.description,
                style: AppStyles.bodySmall.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  height: 1.35,
                ),
              ),
            ],
            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // Metrics row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Qty & Unit
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الكمية',
                      style: AppStyles.bodySmall.copyWith(
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                    Text(
                      '${NumberFormatter.format(item.quantity)} ${item.unit}',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ],
                ),

                // Unit Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سعر الوحدة',
                      style: AppStyles.bodySmall.copyWith(
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                    Text(
                      '${NumberFormatter.format(item.unitPrice)} $currency',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ],
                ),

                // Total Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الإجمالي',
                      style: AppStyles.bodySmall.copyWith(
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                    Text(
                      '${NumberFormatter.format(item.totalPrice)} $currency',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
