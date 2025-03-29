import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import 'package:payvidence/model/sales_model.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_service.dart';
import '../../model/brand_model.dart';
import '../../utilities/payvidence_endpoints.dart';

abstract class ISalesDatasource {
  Future<Sales> fetchSales(String businessId,
      {String? startDate, String? endDate, String? interval});
}

class SalesDatasource extends ISalesDatasource {
  final NetworkService networkService;

  SalesDatasource(this.networkService);

  @override
  Future<Sales> fetchSales(String businessId,
      {String? startDate, String? endDate, String? interval}) async {
    startDate ??= "2024-01-03";
    endDate ??= DateFormat("y-M-d").format(DateTime.now());
    interval ??= "monthly";
    try {
      final Either<Failure, Success> response = await networkService.get(
        '${PayvidenceEndpoints.analytics}?business_id=$businessId&start_date=$startDate&end_date=$endDate&interval=$interval',
        //data: requestData,
        //headers: {"Content-Type": "multipart/form-data"}
      );

      //LoggerService.info("Product Categories:: ${response.toString()}");

      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        // print(success.data);
        return Sales.fromJson(success.data['data']);
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
