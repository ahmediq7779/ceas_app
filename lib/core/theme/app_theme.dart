import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';

class AppTheme {
  AppTheme._();

  /// Dark Slate Grey Theme (Primary Brand Theme)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryOrange,
      scaffoldBackgroundColor: AppColors.darkSlate900,
      fontFamily: 'Roboto', // Fallback standard
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryOrange,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryOrangeDark,
        onPrimaryContainer: Colors.white,
        secondary: AppColors.steelBlueLight,
        onSecondary: Colors.white,
        surface: AppColors.darkSlate800,
        onSurface: AppColors.textPrimaryDark,
        surfaceContainerHighest: AppColors.darkSlate700,
        outline: AppColors.darkSlate600,
        error: AppColors.errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSlate900,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.darkSlate800,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppStyles.radiusMedium,
          side: const BorderSide(color: AppColors.darkSlate700, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSlate950,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.textMutedDark, fontSize: 13),
        labelStyle: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
        border: OutlineInputBorder(
          borderRadius: AppStyles.radiusSmall,
          borderSide: const BorderSide(color: AppColors.darkSlate700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppStyles.radiusSmall,
          borderSide: const BorderSide(color: AppColors.darkSlate700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppStyles.radiusSmall,
          borderSide: const BorderSide(color: AppColors.primaryOrange, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppStyles.radiusSmall,
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.radiusSmall,
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryOrange,
          side: const BorderSide(color: AppColors.primaryOrange, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.radiusSmall,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkSlate700,
        thickness: 1,
        space: 1,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: AppColors.primaryOrange,
        unselectedLabelColor: AppColors.textSecondaryDark,
        indicatorColor: AppColors.primaryOrange,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppColors.darkSlate700,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
    );
  }

  /// Crisp White Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryOrange,
      scaffoldBackgroundColor: AppColors.lightBackground,
      fontFamily: 'Roboto',
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryOrange,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryOrangeLight,
        onPrimaryContainer: Colors.white,
        secondary: AppColors.steelBlue,
        onSecondary: Colors.white,
        surface: AppColors.lightSurface,
        onSurface: AppColors.textPrimaryLight,
        surfaceContainerHighest: AppColors.lightCard,
        outline: AppColors.lightBorderDarker,
        error: AppColors.errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppStyles.radiusMedium,
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.textMutedLight, fontSize: 13),
        labelStyle: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 13),
        border: OutlineInputBorder(
          borderRadius: AppStyles.radiusSmall,
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppStyles.radiusSmall,
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppStyles.radiusSmall,
          borderSide: const BorderSide(color: AppColors.primaryOrange, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.radiusSmall,
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
        space: 1,
      ),
      tabBarTheme: TabBarTheme(
        labelColor: AppColors.primaryOrange,
        unselectedLabelColor: AppColors.textSecondaryLight,
        indicatorColor: AppColors.primaryOrange,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppColors.lightBorder,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
      ),
    );
  }
}
