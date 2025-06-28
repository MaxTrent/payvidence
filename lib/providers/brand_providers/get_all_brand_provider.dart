import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/brand_model.dart';
import '../../repositories/repository/brand_repository.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../business_providers/current_business_provider.dart';

final getAllBrandProvider =
    AsyncNotifierProvider<GetAllBrandNotifier, List<BrandModel>>(() {
  return GetAllBrandNotifier();
});

class GetAllBrandNotifier extends AsyncNotifier<List<BrandModel>> {
  @override
  Future<List<BrandModel>> build() {
    //final userModel = getUser();
    return locator<IBrandRepository>()
        .fetchAllBrand(ref.watch(getCurrentBusinessProvider)!.id!);
  }

  Future<BrandModel> addBrand(Map<String, dynamic> data) {
    return locator<IBrandRepository>()
        .addBrand(ref.watch(getCurrentBusinessProvider)!.id!, data);
  }

  Future<void> deleteBrand(String brandId) async {
    await locator<IBrandRepository>()
        .deleteBrand(ref.watch(getCurrentBusinessProvider)!.id!, brandId);
    ref.invalidateSelf();
  }

// Add methods to mutate the state
}