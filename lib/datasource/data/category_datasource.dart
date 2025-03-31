import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_service.dart';
import '../../model/category_model.dart';
import '../../utilities/payvidence_endpoints.dart';

abstract class ICategoryDatasource {
  Future<List<CategoryModel>> fetchAllCategory(
    String businessId,
  );

  Future<CategoryModel> addCategory(
      String businessId, Map<String, dynamic> requestData);
}

class CategoryDatasource extends ICategoryDatasource {
  final NetworkService networkService;

  CategoryDatasource(this.networkService);

  @override
  Future<List<CategoryModel>> fetchAllCategory(
    String businessId,
  ) async {
    try {
      final Either<Failure, Success> response = await networkService.get(
        '${PayvidenceEndpoints.business}$businessId/category',
        //data: requestData,
        //headers: {"Content-Type": "multipart/form-data"}
      );

      //LoggerService.info("Product Categories:: ${response.toString()}");

      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        List jsonList = success.data['data'] as List;
        // print(success.data);
        return jsonList.map((json) => CategoryModel.fromJson(json)).toList();
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
  Future<CategoryModel> addCategory(
      String businessId, Map<String, dynamic> requestData) async {
    //final NetworkService _networkService = locator<NetworkService>();
    try {
      final Either<Failure, Success> response = await networkService.post(
          '${PayvidenceEndpoints.business}$businessId/category',
          data: requestData);
      //LoggerService.info("Product Categories:: ${response.toString()}");

      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        return CategoryModel.fromJson(success.data);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }

      rethrow;
    }
  }
}
