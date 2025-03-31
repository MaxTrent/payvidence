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
    return locator<ICategoryRepository>()
        .fetchAllCategory(ref.watch(getCurrentBusinessProvider)!.id!);
  }

  Future<CategoryModel> addCategory(Map<String, dynamic> data) {
    return locator<ICategoryRepository>()
        .addCategory(ref.watch(getCurrentBusinessProvider)!.id!, data);
  }

// Add methods to mutate the state
}
