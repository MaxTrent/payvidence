import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:payvidence/model/product_model.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_service.dart';
import '../../utilities/payvidence_endpoints.dart';

abstract class IProductDatasource {
  Future<List<Product>> fetchAllProducts(String businessId,
      {String? brandId, String? name, String? categoryId});

  Future<Product> addProduct(FormData requestData);

  Future<void> deleteProduct(String productId);

  Future<Product> updateProduct(FormData requestData, String productId);

  Future<Product> restockProduct(String productId, int quantity);
}

class ProductDatasource extends IProductDatasource {
  final NetworkService networkService;

  ProductDatasource(this.networkService);

  @override
  Future<List<Product>> fetchAllProducts(String businessId,
      {String? brandId, String? name, String? categoryId}) async {
    try {
      final Either<Failure, Success> response = await networkService.get(
        '${PayvidenceEndpoints.product}?business_id=$businessId&brand_id=${brandId ?? ''}&name=${name ?? ''}&category_id=${categoryId ?? ''}',
        //data: requestData,
        //headers: {"Content-Type": "multipart/form-data"}
      );

      //LoggerService.info("Product Categories:: ${response.toString()}");

      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        List jsonList = success.data['data'] as List;
        // print(success.data);
        return jsonList.map((json) => Product.fromJson(json)).toList();
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
  Future<Product> addProduct(FormData requestData) async {
    //final NetworkService _networkService = locator<NetworkService>();
    try {
      final Either<Failure, Success> response = await networkService.post(
          PayvidenceEndpoints.product,
          data: requestData,
          headers: {"Content-Type": "multipart/form-data"});
      //LoggerService.info("Product Categories:: ${response.toString()}");
      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        return Product.fromJson(success.data['data']);
      });
    } catch (e) {
      print(e);
      if (kDebugMode) {
        print("Error $e");
      }

      rethrow;
    }
  }

  @override
  Future<void> deleteProduct(String productId) async {
    //final NetworkService _networkService = locator<NetworkService>();
    try {
      final Either<Failure, Success> response = await networkService.delete(
        '${PayvidenceEndpoints.product}/$productId',
      );
      //LoggerService.info("Product Categories:: ${response.toString()}");
      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        return;
      });
    } catch (e) {
      print(e);

      if (kDebugMode) {
        print("Error $e");
      }
      rethrow;
    }
  }

  @override
  Future<Product> updateProduct(FormData requestData, String productId) async {
    //final NetworkService _networkService = locator<NetworkService>();
    try {
      final Either<Failure, Success> response = await networkService.post(
          '${PayvidenceEndpoints.product}/$productId',
          data: requestData,
          headers: {"Content-Type": "multipart/form-data"});
      //LoggerService.info("Product Categories:: ${response.toString()}");
      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        return Product.fromJson(success.data['data']);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }

      rethrow;
    }
  }

  @override
  Future<Product> restockProduct(String productId, int quantity) async {
    try {
      final Either<Failure, Success> response = await networkService.post(
        '${PayvidenceEndpoints.product}/$productId/stock',
        data: {"quantity": quantity},
      );
      //LoggerService.info("Product Categories:: ${response.toString()}");
      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        return Product.fromJson(success.data['data']);
      });
    } catch (e) {
      print(e);
      if (kDebugMode) {
        print("Error $e");
      }

      rethrow;
    }
  }
}
