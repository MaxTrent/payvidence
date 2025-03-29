import 'package:dio/dio.dart';
import 'package:payvidence/datasource/data/business_datasource.dart';

import '../../model/business_model.dart';

abstract class IBusinessRepository {
  Future<Business> addBusiness(FormData requestData);

  Future<List<Business>> fetchAllBusiness();

  Future<Business> fetchBusiness(String id);

  Future<Business> updateBusiness(String id, Map<String, dynamic> requestData);
}

class BusinessRepository extends IBusinessRepository {
  final IBusinessDatasource businessDatasource;

  BusinessRepository(this.businessDatasource);

  @override
  Future<Business> addBusiness(FormData requestData) {
    return businessDatasource.addBusiness(requestData);
  }

  @override
  Future<List<Business>> fetchAllBusiness() {
    return businessDatasource.fetchAllBusiness();
  }

  @override
  Future<Business> fetchBusiness(String id) {
    return businessDatasource.fetchBusiness(id);
  }

  @override
  Future<Business> updateBusiness(String id, Map<String, dynamic> requestData) {
    return businessDatasource.updateBusiness(id, requestData);
  }
}
