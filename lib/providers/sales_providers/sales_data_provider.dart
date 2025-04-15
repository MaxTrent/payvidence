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
    final Map<String, dynamic> filterData = ref.read(salesFilterProvider);

    //final userModel = getUser();
    return locator<ISalesRepository>().fetchSales(
        ref.watch(getCurrentBusinessProvider)!.id!,
        interval: filterData['interval'],
        startDate: filterData['startDate'],
        endDate: filterData['endDate']);
  }

  Future<void> setFilter() async {
    final Map<String, dynamic> filterData = ref.read(salesFilterProvider);
    state = AsyncData(await locator<ISalesRepository>().fetchSales(
        ref.watch(getCurrentBusinessProvider)!.id!,
        interval: filterData['interval'],
        startDate: filterData['startDate'],
        endDate: filterData['endDate']));
    //name: filterData['name'] ?? ''));
  }
}
