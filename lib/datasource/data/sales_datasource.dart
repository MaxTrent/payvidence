import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:payvidence/model/sales_model.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_service.dart';
import '../../model/brand_model.dart';
import '../../utilities/payvidence_endpoints.dart';

abstract class ISalesDatasource {
  Future<List<Sales>> fetchSales(String businessId,
      {String? startDate, String? endDate, String? interval});
}

class SalesDatasource extends ISalesDatasource {
  final NetworkService networkService;

  SalesDatasource(this.networkService);

  @override
  Future<List<Sales>> fetchSales(String businessId,
      {String? startDate = "2024-01-03",
      String? endDate = "2024-03-26",
      String? interval = "monthly"}) async {
    try {
      final Either<Failure, Success> response = await networkService.get(
        '${PayvidenceEndpoints.analytics}?$businessId=$businessId&start_date=$startDate&end_date=$endDate&interval=$interval',
        //data: requestData,
        //headers: {"Content-Type": "multipart/form-data"}
      );

      //LoggerService.info("Product Categories:: ${response.toString()}");

      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        List jsonList = success.data['data'] as List;
        // print(success.data);
        return jsonList.map((json) => Sales.fromJson(json)).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print("here");

        print("Error $e");
      }

      rethrow;
    }
  }
}
