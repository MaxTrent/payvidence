import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/providers/brand_providers/current_brand_provider.dart';
import 'package:payvidence/providers/brand_providers/get_all_brand_provider.dart';
import 'package:payvidence/providers/category_providers/current_category_provider.dart';
import 'package:payvidence/providers/category_providers/get_all_category_provider.dart';
import 'package:payvidence/providers/product_providers/current_product_provider.dart';
import 'package:payvidence/providers/product_providers/get_all_product_provider.dart';
import 'package:payvidence/providers/product_providers/product_fillter_provider.dart';

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

  void setCurrentBusiness(Business business) {
    if (state != business) {
      state = business;
      ref.invalidate(getCurrentProductProvider);
      ref.invalidate(getCurrentBrandProvider);
      ref.invalidate(getCurrentCategoryProvider);
      ref.invalidate(getAllProductProvider);
      ref.invalidate(getAllCategoryProvider);
      ref.invalidate(getAllBrandProvider);
      ref.invalidate(productFilterProvider);
    }
  }
// Add methods to mutate the state
}
