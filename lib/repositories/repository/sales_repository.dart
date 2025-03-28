import 'package:dio/dio.dart';
import 'package:payvidence/datasource/data/product_datasource.dart';
import 'package:payvidence/model/product_model.dart';

import '../../datasource/data/receipt_datasource.dart';
import '../../datasource/data/sales_datasource.dart';
import '../../model/receipt_model.dart';
import '../../model/sales_model.dart';

abstract class ISalesRepository {
  Future<List<Sales>> fetchSales(String businessId,
      {String? startDate, String? endDate, String? interval});
}

class SalesRepository extends ISalesRepository {
  final ISalesDatasource salesDatasource;

  SalesRepository(this.salesDatasource);

  @override
  Future<List<Sales>> fetchSales(String businessId,
      {String? startDate, String? endDate, String? interval}) {
    return salesDatasource.fetchSales(businessId,
        startDate: startDate, endDate: endDate, interval: interval);
  }
}
