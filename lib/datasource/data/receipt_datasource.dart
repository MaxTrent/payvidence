import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:payvidence/model/receipt_model.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_service.dart';
import '../../utilities/payvidence_endpoints.dart';

abstract class IReceiptDatasource {
  Future<Receipt> createReceipt(Map<String, dynamic> requestData);

  Future<List<Receipt>> fetchAllReceipts(String businessId, String? recordType);

  Future<Receipt> updateReceipt(
      String recordId, Map<String, dynamic> requestData, bool? publish);

  Future<Receipt> invoiceToReceipt(
      String recordId, Map<String, dynamic> requestData);

  Future<Receipt> publishReceipt(String recordId);

  Future<void> deleteReceipt(String receiptId);
}

class ReceiptDatasource extends IReceiptDatasource {
  final NetworkService networkService;

  ReceiptDatasource(this.networkService);

  @override
  Future<Receipt> createReceipt(Map<String, dynamic> requestData) async {
    //final NetworkService _networkService = locator<NetworkService>();
    try {
      final Either<Failure, Success> response = await networkService
          .post(PayvidenceEndpoints.saleRecord, data: requestData);
      //LoggerService.info("Product Categories:: ${response.toString()}");

      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        return Receipt.fromJson(success.data["data"]);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }

      rethrow;
    }
  }

  @override
  Future<List<Receipt>> fetchAllReceipts(
      String businessId, String? recordType) async {
    try {
      final Either<Failure, Success> response = await networkService.get(
        '${PayvidenceEndpoints.saleRecord}?business_id=$businessId&record_type=${recordType ?? ''}',
        //data: requestData,
        //headers: {"Content-Type": "multipart/form-data"}
      );

      //LoggerService.info("Product Categories:: ${response.toString()}");

      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        List jsonList = success.data['data'] as List;
        // print(success.data);
        return jsonList.map((json) => Receipt.fromJson(json)).toList();
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
  Future<void> deleteReceipt(String receiptId) async {
    try {
      final Either<Failure, Success> response = await networkService.delete(
        '${PayvidenceEndpoints.saleRecord}/$receiptId',
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
  Future<Receipt> updateReceipt(
      String recordId, Map<String, dynamic> requestData, bool? publish) async {
    try {
      final Either<Failure, Success> response = await networkService.patch(
          '${PayvidenceEndpoints.saleRecord}/$recordId',
          data: requestData);
      //LoggerService.info("Product Categories:: ${response.toString()}");

      return response.fold((fail) {
        throw fail.error;
      }, (success) async {
        if (publish == true) {
          return await publishReceipt(recordId);
        } else {
          return Receipt.fromJson(success.data["data"]);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }

      rethrow;
    }
  }

  @override
  Future<Receipt> publishReceipt(String recordId) async {
    try {
      final Either<Failure, Success> response = await networkService.post(
        '${PayvidenceEndpoints.saleRecord}/$recordId/publish',
      );
      //LoggerService.info("Product Categories:: ${response.toString()}");

      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        return Receipt.fromJson(success.data["data"]);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }

      rethrow;
    }
  }

  @override
  Future<Receipt> invoiceToReceipt(
      String recordId, Map<String, dynamic> requestData) async {
    try {
      final Either<Failure, Success> response = await networkService.post(
          '${PayvidenceEndpoints.saleRecord}/$recordId/generate-receipt',
          data: requestData);
      //LoggerService.info("Product Categories:: ${response.toString()}");

      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        return Receipt.fromJson(success.data["data"]);
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }

      rethrow;
    }
  }
}
