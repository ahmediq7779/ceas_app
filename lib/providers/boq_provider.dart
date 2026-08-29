import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/boq_item_model.dart';
import '../services/storage_service.dart';
import 'rate_settings_provider.dart';

class BoqNotifier extends StateNotifier<List<BoqItemModel>> {
  final StorageService _storage;

  BoqNotifier(this._storage) : super(_storage.loadBoqItems());

  Future<void> addItem(BoqItemModel item) async {
    state = [item, ...state];
    await _storage.saveBoqItems(state);
  }

  Future<void> updateItem(BoqItemModel updatedItem) async {
    state = [
      for (final item in state)
        if (item.id == updatedItem.id) updatedItem else item
    ];
    await _storage.saveBoqItems(state);
  }

  Future<void> deleteItem(String id) async {
    state = state.where((item) => item.id != id).toList();
    await _storage.saveBoqItems(state);
  }

  Future<void> clearAll() async {
    state = [];
    await _storage.saveBoqItems(state);
  }
}

final boqProvider = StateNotifierProvider<BoqNotifier, List<BoqItemModel>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return BoqNotifier(storage);
});

/// Total Project BOQ Cost Computed Provider
final boqTotalCostProvider = Provider<double>((ref) {
  final items = ref.watch(boqProvider);
  return items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
});

/// BOQ Items Count Provider
final boqItemsCountProvider = Provider<int>((ref) {
  final items = ref.watch(boqProvider);
  return items.length;
});
