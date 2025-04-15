import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final salesDateFilterProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

final salesFilterProvider =
    NotifierProvider<SalesFilterNotifier, Map<String, dynamic>>(() {
  return SalesFilterNotifier();
});

class SalesFilterNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    return {
      "interval": "weekly",
      "startDate": DateFormat("y-M-d").format(
          ref.read(salesDateFilterProvider).subtract(const Duration(days: 7))),
      "endDate": DateFormat("y-M-d").format(ref.read(salesDateFilterProvider))
    };
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
