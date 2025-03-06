import 'package:payvidence/model/brand_model.dart';

import '../../datasource/data/brand_datasource.dart';

abstract class IBrandRepository {
  Future<BrandModel> addBrand(
      String businessId, Map<String, dynamic> requestData);

  Future<List<BrandModel>> fetchAllBrand(String businessId);

//Future<Business> fetchBusiness(String id);
}

class BrandRepository extends IBrandRepository {
  final IBrandDatasource brandDatasource;

  BrandRepository(this.brandDatasource);

  @override
  Future<BrandModel> addBrand(
      String businessId, Map<String, dynamic> requestData) {
    return brandDatasource.addBrand(businessId, requestData);
  }

  @override
  Future<List<BrandModel>> fetchAllBrand(String businessId) {
    return brandDatasource.fetchAllBrand(businessId);
  }

// @override
// Future<Business> fetchBusiness(String id) {
//   return businessDatasource.fetchBusiness(id);
// }
}
