import 'package:payvidence/model/category_model.dart';

import '../../datasource/data/category_datasource.dart';

abstract class ICategoryRepository {
  Future<CategoryModel> addCategory(
      String businessId, Map<String, dynamic> requestData);

  Future<List<CategoryModel>> fetchAllCategory(String businessId);

  Future<void> deleteCategory(String businessId, String categoryId);

//Future<Business> fetchBusiness(String id);
}

class CategoryRepository extends ICategoryRepository {
  final ICategoryDatasource categoryDatasource;

  CategoryRepository(this.categoryDatasource);

  @override
  Future<CategoryModel> addCategory(
      String businessId, Map<String, dynamic> requestData) {
    return categoryDatasource.addCategory(businessId, requestData);
  }

  @override
  Future<List<CategoryModel>> fetchAllCategory(String businessId) {
    return categoryDatasource.fetchAllCategory(businessId);
  }

  @override
  Future<void> deleteCategory(String businessId, String categoryId) {
    return categoryDatasource.deleteCategory(businessId, categoryId);
  }

// @override
// Future<Business> fetchBusiness(String id) {
//   return businessDatasource.fetchBusiness(id);
// }
}