import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/business_model.dart';

final productFilterProvider =
    NotifierProvider<ProductFilterNotifier, Map<String, dynamic>>(() {
  return ProductFilterNotifier();
});

class ProductFilterNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  void setKey(String key, dynamic value) {
    state = {...state, key: value};
  }

  void removeKey(String key) {
    state.remove(key);
  }

  void removeFilter() {
    state = {};
  }
// Add methods to mutate the state
}
