
import '../../datasource/data/sales_datasource.dart';
import '../../model/sales_model.dart';

abstract class ISalesRepository {
  Future<Sales> fetchSales(String businessId,
      {String? startDate, String? endDate, String? interval});
}

class SalesRepository extends ISalesRepository {
  final ISalesDatasource salesDatasource;

  SalesRepository(this.salesDatasource);

  @override
  Future<Sales> fetchSales(String businessId,
      {String? startDate, String? endDate, String? interval}) {
    return salesDatasource.fetchSales(businessId,
        startDate: startDate, endDate: endDate, interval: interval);
  }
}
