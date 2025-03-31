import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_service.dart';
import '../../model/brand_model.dart';
import '../../utilities/payvidence_endpoints.dart';

abstract class IBrandDatasource {
  Future<List<BrandModel>> fetchAllBrand(
    String businessId,
  );

  Future<BrandModel> addBrand(
      String businessId, Map<String, dynamic> requestData);
}

class BrandDatasource extends IBrandDatasource {
  final NetworkService networkService;

  BrandDatasource(this.networkService);

  @override
  Future<List<BrandModel>> fetchAllBrand(
    String businessId,
  ) async {
    try {
      final Either<Failure, Success> response = await networkService.get(
        '${PayvidenceEndpoints.business}$businessId/brand',
        //data: requestData,
        //headers: {"Content-Type": "multipart/form-data"}
      );

      //LoggerService.info("Product Categories:: ${response.toString()}");

      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        List jsonList = success.data['data'] as List;
        // print(success.data);
        return jsonList.map((json) => BrandModel.fromJson(json)).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print("here");

        print("Error $e");
      }

      rethrow;
    }
  }

  @override
  Future<BrandModel> addBrand(
      String businessId, Map<String, dynamic> requestData) async {
    //final NetworkService _networkService = locator<NetworkService>();
    try {
      final Either<Failure, Success> response = await networkService.post(
          '${PayvidenceEndpoints.business}$businessId/brand',
          data: requestData);
      //LoggerService.info("Product Categories:: ${response.toString()}");

      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        return BrandModel.fromJson(success.data);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }

      rethrow;
    }
  }
}
