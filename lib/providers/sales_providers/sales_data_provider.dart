import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/providers/sales_providers/sales_fillter_provider.dart';

import '../../model/sales_model.dart';
import '../../repositories/repository/sales_repository.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../business_providers/current_business_provider.dart';

final salesDataProvider =
    AsyncNotifierProvider<GetSalesDataNotifier, Sales>(() {
  return GetSalesDataNotifier();
});

class GetSalesDataNotifier extends AsyncNotifier<Sales> {
  @override
  Future<Sales> build() {
    final currentBusiness = ref.read(getCurrentBusinessProvider);
    if (currentBusiness?.id == null) {
      return Future.value(Sales(totalSales: 0, totalRevenue: 0, graphData: []));
    }
    
    final Map<String, dynamic> filterData = ref.read(salesFilterProvider);
    return locator<ISalesRepository>().fetchSales(
        currentBusiness!.id!,
        interval: filterData['interval'],
        startDate: filterData['startDate'],
        endDate: filterData['endDate']);
  }

  Future<void> setFilter() async {
    final currentBusiness = ref.read(getCurrentBusinessProvider);
    if (currentBusiness?.id == null) {
      state = AsyncData(Sales(totalSales: 0, totalRevenue: 0, graphData: []));
      return;
    }
    
    final Map<String, dynamic> filterData = ref.read(salesFilterProvider);
    state = AsyncData(await locator<ISalesRepository>().fetchSales(
        currentBusiness!.id!,
        interval: filterData['interval'],
        startDate: filterData['startDate'],
        endDate: filterData['endDate']));
  }

  Future<void> refreshSales(String businessId) async {
    state = const AsyncLoading();
    try {
      final Map<String, dynamic> filterData = ref.read(salesFilterProvider);
      final sales = await locator<ISalesRepository>().fetchSales(
          businessId,
          interval: filterData['interval'],
          startDate: filterData['startDate'],
          endDate: filterData['endDate']);
      state = AsyncData(sales);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
