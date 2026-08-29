import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../utils/haptic_service.dart';

enum ButtonType { primary, secondary, outline, danger }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = 48,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? borderSide;

    switch (type) {
      case ButtonType.primary:
        backgroundColor = AppColors.primaryOrange;
        foregroundColor = Colors.white;
        borderSide = null;
        break;
      case ButtonType.secondary:
        backgroundColor = isDark ? AppColors.darkSlate700 : AppColors.lightBorder;
        foregroundColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
        borderSide = null;
        break;
      case ButtonType.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.primaryOrange;
        borderSide = const BorderSide(color: AppColors.primaryOrange, width: 1.5);
        break;
      case ButtonType.danger:
        backgroundColor = AppColors.errorRed.withOpacity(0.15);
        foregroundColor = AppColors.errorRed;
        borderSide = const BorderSide(color: AppColors.errorRed, width: 1);
        break;
    }

    Widget content = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
        : Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: foregroundColor),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: TextStyle(
                  color: foregroundColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: Material(
        color: backgroundColor,
        borderRadius: AppStyles.radiusSmall,
        shape: borderSide != null
            ? RoundedRectangleBorder(
                borderRadius: AppStyles.radiusSmall,
                side: borderSide,
              )
            : null,
        child: InkWell(
          borderRadius: AppStyles.radiusSmall,
          onTap: (isLoading || onPressed == null)
              ? null
              : () {
                  HapticService.light();
                  onPressed!();
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(child: content),
          ),
        ),
      ),
    );
  }
}
