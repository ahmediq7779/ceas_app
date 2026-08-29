import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rate_settings_model.dart';
import '../models/boq_item_model.dart';

/// Storage service for local persistence using SharedPreferences
class StorageService {
  static const String _keyRateSettings = 'ceas_rate_settings';
  static const String _keyBoqItems = 'ceas_boq_items';
  static const String _keyThemeMode = 'ceas_theme_mode';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Initialize StorageService with SharedPreferences instance
  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // --- Rates Settings ---

  RateSettingsModel loadRateSettings() {
    try {
      final jsonStr = _prefs.getString(_keyRateSettings);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        return RateSettingsModel.fromJson(jsonStr);
      }
    } catch (_) {}
    return const RateSettingsModel();
  }

  Future<bool> saveRateSettings(RateSettingsModel rates) async {
    try {
      return await _prefs.setString(_keyRateSettings, rates.toJson());
    } catch (_) {
      return false;
    }
  }

  // --- BOQ Items ---

  List<BoqItemModel> loadBoqItems() {
    try {
      final jsonListStr = _prefs.getStringList(_keyBoqItems);
      if (jsonListStr != null) {
        return jsonListStr
            .map((itemStr) => BoqItemModel.fromJson(itemStr))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  Future<bool> saveBoqItems(List<BoqItemModel> items) async {
    try {
      final jsonListStr = items.map((item) => item.toJson()).toList();
      return await _prefs.setStringList(_keyBoqItems, jsonListStr);
    } catch (_) {
      return false;
    }
  }

  // --- Theme Mode ---

  bool loadIsDarkMode() {
    return _prefs.getBool(_keyThemeMode) ?? true;
  }

  Future<bool> saveIsDarkMode(bool isDark) async {
    return await _prefs.setBool(_keyThemeMode, isDark);
  }
}
