import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class ResultItem {
  final String label;
  final String value;
  final String unit;
  final String? subtitle;
  final IconData? icon;
  final bool isHighlight;

  const ResultItem({
    required this.label,
    required this.value,
    required this.unit,
    this.subtitle,
    this.icon,
    this.isHighlight = false,
  });
}

class ResultCard extends StatelessWidget {
  final String title;
  final List<ResultItem> items;
  final String? totalCostText;
  final VoidCallback? onAddToBoq;
  final String? addToBoqLabel;
  final IconData headerIcon;

  const ResultCard({
    Key? key,
    required this.title,
    required this.items,
    this.totalCostText,
    this.onAddToBoq,
    this.addToBoqLabel,
    this.headerIcon = Icons.analytics_outlined,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSlate800 : AppColors.lightSurface,
        borderRadius: AppStyles.radiusMedium,
        border: Border.all(
          color: AppColors.primaryOrange.withOpacity(0.35),
          width: 1.2,
        ),
        boxShadow: isDark ? AppStyles.cardShadowDark : AppStyles.cardShadowLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.primaryOrange.withOpacity(0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(headerIcon, color: AppColors.primaryOrange, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: AppStyles.heading3.copyWith(
                      color: AppColors.primaryOrange,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items Grid / List
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...items.map((item) => _buildResultRow(context, item, isDark)),
                if (totalCostText != null) ...[
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.successGreen.withOpacity(0.1),
                      borderRadius: AppStyles.radiusSmall,
                      border: Border.all(
                        color: AppColors.successGreen.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.monetization_on_outlined,
                              color: AppColors.successGreen,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'التكلفة التقديرية:',
                              style: AppStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          totalCostText!,
                          style: AppStyles.statValue.copyWith(
                            fontSize: 16,
                            color: AppColors.successGreen,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (onAddToBoq != null) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onAddToBoq,
                      icon: const Icon(Icons.playlist_add_rounded, size: 20),
                      label: Text(
                        addToBoqLabel ?? 'إضافة لجدول الكميات (BOQ)',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(BuildContext context, ResultItem item, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (item.icon != null) ...[
            Icon(
              item.icon,
              size: 16,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: AppStyles.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                if (item.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle!,
                    style: AppStyles.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                item.value,
                style: AppStyles.statValue.copyWith(
                  fontSize: 16,
                  color: item.isHighlight
                      ? AppColors.primaryOrange
                      : (isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                item.unit,
                style: AppStyles.statUnit,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
