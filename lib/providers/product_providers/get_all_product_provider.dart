import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/product_model.dart';
import 'package:payvidence/providers/business_providers/current_business_provider.dart';
import 'package:payvidence/providers/product_providers/product_fillter_provider.dart';
import 'package:payvidence/repositories/repository/product_repository.dart';

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

  Future<void> deleteProduct(
    String productId,
  ) async {
    try {
      await locator<IProductRepository>().deleteProduct(productId);
      await setFilter();
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> updateProduct(
    FormData requestData,
    String productId,
  ) async {
    try {
      return await locator<IProductRepository>()
          .updateProduct(requestData, productId);
    } catch (e) {
      rethrow;
    }
  }

  Future<Product> restockProduct(String productId, int quantity) async {
    try {
      return await locator<IProductRepository>()
          .restockProduct(productId, quantity);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setFilter() async {
    final Map<String, dynamic> filterData = ref.read(productFilterProvider);
    print(filterData);
    state = AsyncData(await locator<IProductRepository>().fetchAllProduct(
        ref.watch(getCurrentBusinessProvider)!.id!,
        categoryId: filterData['category_id'] ?? '',
        name: filterData['name'] ?? ''));
  }
// Add methods to mutate the state
}
