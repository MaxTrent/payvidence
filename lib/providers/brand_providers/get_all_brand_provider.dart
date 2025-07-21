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
  Future<List<BrandModel>> build() async {
    try {
      final currentBusiness = ref.read(getCurrentBusinessProvider);
      if (currentBusiness?.id == null) {
        return [];
      }
      return await locator<IBrandRepository>()
          .fetchAllBrand(currentBusiness!.id!);
    } catch (e) {
      // Log the error but return empty list to prevent app crashes
      print('Error fetching brands: $e');
      return [];
    }
  }

  Future<BrandModel> addBrand(Map<String, dynamic> data) {
    final currentBusiness = ref.read(getCurrentBusinessProvider);
    if (currentBusiness?.id == null) {
      throw Exception('No business selected');
    }
    return locator<IBrandRepository>()
        .addBrand(currentBusiness!.id!, data);
  }

  Future<void> deleteBrand(String brandId) async {
    final currentBusiness = ref.read(getCurrentBusinessProvider);
    if (currentBusiness?.id == null) {
      throw Exception('No business selected');
    }
    await locator<IBrandRepository>()
        .deleteBrand(currentBusiness!.id!, brandId);
    ref.invalidateSelf();
  }

  Future<void> refreshBrands(String businessId) async {
    state = const AsyncLoading();
    try {
      final brands = await locator<IBrandRepository>().fetchAllBrand(businessId);
      state = AsyncData(brands);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

// Add methods to mutate the state
}