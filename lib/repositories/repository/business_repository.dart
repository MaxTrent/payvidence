import 'package:dio/dio.dart';
import 'package:payvidence/datasource/data/business_datasource.dart';

import '../../model/business_model.dart';

abstract class IBusinessRepository{
  Future<Business> addBusiness(FormData requestData);

}

class BusinessRepository extends IBusinessRepository{
  final IBusinessDatasource businessDatasource;
  BusinessRepository(this.businessDatasource);

  @override
  Future<Business> addBusiness(FormData requestData) {
    return businessDatasource.addBusiness(requestData);
  }

}