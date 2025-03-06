import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/brand_model.dart';

final getCurrentBrandProvider =
NotifierProvider<GetCurrentBrandNotifier, BrandModel?>(() {
  return GetCurrentBrandNotifier();
});

class GetCurrentBrandNotifier extends Notifier<BrandModel?> {
  @override
  BrandModel? build() {
    //final userModel = getUser();
    return null;
  }
  void setCurrentBrand(BrandModel brand){
    state = brand;
  }
// Add methods to mutate the state
}