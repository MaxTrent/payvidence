import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/category_model.dart';

import '../../repositories/repository/category_repository.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../business_providers/current_business_provider.dart';

final getAllCategoryProvider =
    AsyncNotifierProvider<GetAllCategoryNotifier, List<CategoryModel>>(() {
  return GetAllCategoryNotifier();
});

class GetAllCategoryNotifier extends AsyncNotifier<List<CategoryModel>> {
  @override
  Future<List<CategoryModel>> build() {
    //final userModel = getUser();
    final currentBusiness = ref.read(getCurrentBusinessProvider);
    if (currentBusiness?.id == null) {
      return Future.value([]);
    }
    return locator<ICategoryRepository>()
        .fetchAllCategory(currentBusiness!.id!);
  }

  Future<CategoryModel> addCategory(Map<String, dynamic> data) {
    final currentBusiness = ref.read(getCurrentBusinessProvider);
    if (currentBusiness?.id == null) {
      throw Exception('No business selected');
    }
    return locator<ICategoryRepository>()
        .addCategory(currentBusiness!.id!, data);
  }

  Future<void> deleteCategory(String categoryId) async {
    final currentBusiness = ref.read(getCurrentBusinessProvider);
    if (currentBusiness?.id == null) {
      throw Exception('No business selected');
    }
    await locator<ICategoryRepository>()
        .deleteCategory(currentBusiness!.id!, categoryId);
    ref.invalidateSelf();
  }

  Future<void> refreshCategories(String businessId) async {
    state = const AsyncLoading();
    try {
      final categories = await locator<ICategoryRepository>().fetchAllCategory(businessId);
      state = AsyncData(categories);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

// Add methods to mutate the state
}