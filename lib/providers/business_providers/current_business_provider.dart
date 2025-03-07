import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/business_model.dart';

final getCurrentBusinessProvider =
NotifierProvider<GetCurrentBusinessNotifier, Business?>(() {
  return GetCurrentBusinessNotifier();
});

class GetCurrentBusinessNotifier extends Notifier<Business?> {
  @override
  Business? build() {
    //final userModel = getUser();
    return null;
  }
  void setCurrentBusiness(Business business){
    state = business;
  }
// Add methods to mutate the state
}