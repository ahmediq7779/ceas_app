import 'package:intl/intl.dart';

/// Number formatting utility for engineering calculations
class NumberFormatter {
  NumberFormatter._();

  static final NumberFormat _decimalFormatter = NumberFormat('#,##0.##', 'en_US');
  static final NumberFormat _currencyFormatter = NumberFormat('#,##0.00', 'en_US');
  static final NumberFormat _integerFormatter = NumberFormat('#,##0', 'en_US');

  /// Formats engineering numbers cleanly (up to 2 decimals, removing trailing zeros)
  static String format(double? value, {int maxDecimals = 2}) {
    if (value == null || value.isNaN || value.isInfinite) return '0';
    if (maxDecimals == 0) return _integerFormatter.format(value.round());
    if (maxDecimals == 2) return _decimalFormatter.format(value);
    
    final customFormat = NumberFormat.currency(
      decimalDigits: maxDecimals,
      symbol: '',
    );
    return customFormat.format(value).trim();
  }

  /// Formats financial amounts
  static String formatCurrency(double? value, {String symbol = ''}) {
    if (value == null || value.isNaN || value.isInfinite) return '0.00 $symbol'.trim();
    final formatted = _currencyFormatter.format(value);
    return symbol.isNotEmpty ? '$formatted $symbol' : formatted;
  }

  /// Parses string to double safely
  static double parseDouble(String text, {double defaultValue = 0.0}) {
    if (text.trim().isEmpty) return defaultValue;
    // Replace Arabic numbers with Western numbers if user typed in Arabic digits
    final normalized = text
        .replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9')
        .replaceAll('،', '.')
        .replaceAll(',', '.')
        .trim();
    return double.tryParse(normalized) ?? defaultValue;
  }

  /// Parses string to integer safely
  static int parseInt(String text, {int defaultValue = 0}) {
    return parseDouble(text, defaultValue: defaultValue.toDouble()).round();
  }
}
