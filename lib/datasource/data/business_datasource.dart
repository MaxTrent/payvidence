import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:payvidence/model/business_model.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';

import '../../data/network/api_response.dart';
import '../../data/network/network_service.dart';
import '../../utilities/payvidence_endpoints.dart';

abstract class IBusinessDatasource {
  Future<Business> addBusiness(FormData requestData);
}

class BusinessDatasource extends IBusinessDatasource {
  final NetworkService networkService;

  BusinessDatasource(this.networkService);

  @override
  Future<Business> addBusiness(FormData requestData) async {
    //final NetworkService _networkService = locator<NetworkService>();
    try {
      final Either<Failure, Success> response = await networkService.post(
          PayvidenceEndpoints.createBusiness,
          data: requestData,
          headers: {"Content-Type": "multipart/form-data"});
      //LoggerService.info("Product Categories:: ${response.toString()}");

      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        return Business.fromJson(success.data);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }

      rethrow;
    }
  }
}
