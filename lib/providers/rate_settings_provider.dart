import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/rate_settings_model.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be overridden in ProviderScope');
});

class RateSettingsNotifier extends StateNotifier<RateSettingsModel> {
  final StorageService _storage;

  RateSettingsNotifier(this._storage) : super(_storage.loadRateSettings());

  Future<void> updateRates(RateSettingsModel newRates) async {
    state = newRates;
    await _storage.saveRateSettings(newRates);
  }

  Future<void> resetToDefaults() async {
    const defaultRates = RateSettingsModel();
    state = defaultRates;
    await _storage.saveRateSettings(defaultRates);
  }
}

final rateSettingsProvider =
    StateNotifierProvider<RateSettingsNotifier, RateSettingsModel>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return RateSettingsNotifier(storage);
});
