import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'store_model.dart';

final storeProvider = StateNotifierProvider<StoreNotifier, StoreModel?>((ref) {
  return StoreNotifier();
});

class StoreNotifier extends StateNotifier<StoreModel?> {
  StoreNotifier() : super(null);

  void setStore(StoreModel store) {
    state = store;
  }

  void clear() {
    state = null;
  }
}