import 'number_formatter.dart';
import '../constants/app_strings.dart';

/// Form and input validators for engineering fields
class Validators {
  Validators._();

  /// Validates positive double values (> 0)
  static String? positiveDouble(String? value, {bool allowZero = false}) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    final parsed = NumberFormatter.parseDouble(value, defaultValue: -1);
    if (parsed < 0) {
      return AppStrings.invalidNumber;
    }
    if (!allowZero && parsed == 0) {
      return AppStrings.invalidNumber;
    }
    return null;
  }

  /// Validates positive integer values
  static String? positiveInt(String? value, {bool allowZero = false}) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    final parsed = NumberFormatter.parseInt(value, defaultValue: -1);
    if (parsed < 0) {
      return AppStrings.invalidNumber;
    }
    if (!allowZero && parsed == 0) {
      return AppStrings.invalidNumber;
    }
    return null;
  }

  /// Validates percentage (0 to 100)
  static String? percentage(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    final parsed = NumberFormatter.parseDouble(value, defaultValue: -1);
    if (parsed < 0 || parsed > 100) {
      return 'القيمة يجب أن تكون بين 0 و 100%';
    }
    return null;
  }

  /// Validates non-empty string
  static String? requiredText(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    return null;
  }
}
