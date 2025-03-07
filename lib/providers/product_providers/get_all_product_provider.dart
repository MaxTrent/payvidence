import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/product_model.dart';
import 'package:payvidence/providers/business_providers/current_business_provider.dart';
import 'package:payvidence/repositories/repository/business_repository.dart';
import 'package:payvidence/repositories/repository/product_repository.dart';

import '../../model/business_model.dart';
import '../../shared_dependency/shared_dependency.dart';

final getAllProductProvider =
    AsyncNotifierProvider<GetAllProductNotifier, List<Product>>(() {
  return GetAllProductNotifier();
});

class GetAllProductNotifier extends AsyncNotifier<List<Product>> {
  @override
  Future<List<Product>> build() {
    //final userModel = getUser();
    return locator<IProductRepository>()
        .fetchAllProduct(ref.watch(getCurrentBusinessProvider)!.id!);
  }

// Add methods to mutate the state
}
