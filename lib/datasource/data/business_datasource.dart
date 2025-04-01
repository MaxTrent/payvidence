import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:payvidence/model/business_model.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_service.dart';
import '../../utilities/payvidence_endpoints.dart';

abstract class IBusinessDatasource {
  Future<Business> addBusiness(FormData requestData);

  Future<Business> updateBusiness(String id, Map<String, dynamic> requestData);

  Future<List<Business>> fetchAllBusiness();

  Future<Business> fetchBusiness(String id);
}

class BusinessDatasource extends IBusinessDatasource {
  final NetworkService networkService;

  BusinessDatasource(this.networkService);

  @override
  Future<Business> addBusiness(FormData requestData) async {
    //final NetworkService _networkService = locator<NetworkService>();
    try {
      final Either<Failure, Success> response = await networkService.post(
          PayvidenceEndpoints.business,
          data: requestData,
          headers: {"Content-Type": "multipart/form-data"});
      //LoggerService.info("Product Categories:: ${response.toString()}");

      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        return Business.fromJson(success.data["data"]);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }

      rethrow;
    }
  }

  @override
  Future<List<Business>> fetchAllBusiness() async {
    try {
      final Either<Failure, Success> response = await networkService.get(
        PayvidenceEndpoints.business,
        //data: requestData,
        //headers: {"Content-Type": "multipart/form-data"}
      );

      //LoggerService.info("Product Categories:: ${response.toString()}");

      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        List jsonList = success.data['data'] as List;
        // print(success.data);
        return jsonList.map((json) => Business.fromJson(json)).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }

      rethrow;
    }
  }

  @override
  Future<Business> fetchBusiness(String id) async {
    try {
      final Either<Failure, Success> response = await networkService.get(
        '${PayvidenceEndpoints.business}/$id',
        //data: requestData,
        //headers: {"Content-Type": "multipart/form-data"}
      );
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

  @override
  Future<Business> updateBusiness(
      String id, Map<String, dynamic> requestData) async {
    try {
      final Either<Failure, Success> response = await networkService.patch(
        '${PayvidenceEndpoints.business}/$id',
        data: requestData,
      );
      //LoggerService.info("Product Categories:: ${response.toString()}");

      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        return Business.fromJson(success.data["data"]);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }

      rethrow;
    }
  }
}
