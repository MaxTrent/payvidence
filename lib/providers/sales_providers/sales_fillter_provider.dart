import 'package:flutter_riverpod/flutter_riverpod.dart';

final salesFilterProvider =
    NotifierProvider<SalesFilterNotifier, Map<String, dynamic>>(() {
  return SalesFilterNotifier();
});

class SalesFilterNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    return {"interval": "weekly"};
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
