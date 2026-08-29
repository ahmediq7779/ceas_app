import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';
import 'rate_settings_provider.dart';

class ThemeModeNotifier extends StateNotifier<bool> {
  final StorageService _storage;

  ThemeModeNotifier(this._storage) : super(_storage.loadIsDarkMode());

  Future<void> toggleTheme() async {
    final newValue = !state;
    state = newValue;
    await _storage.saveIsDarkMode(newValue);
  }

  Future<void> setDarkMode(bool isDark) async {
    state = isDark;
    await _storage.saveIsDarkMode(isDark);
  }
}

final isDarkModeProvider = StateNotifierProvider<ThemeModeNotifier, bool>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ThemeModeNotifier(storage);
});
