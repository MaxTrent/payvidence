import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/sales_model.dart';
import '../../repositories/repository/sales_repository.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../business_providers/current_business_provider.dart';

final salesDataProvider =
    AsyncNotifierProvider<GetSalesDataNotifier, List<Sales>>(() {
  return GetSalesDataNotifier();
});

class GetSalesDataNotifier extends AsyncNotifier<List<Sales>> {
  @override
  Future<List<Sales>> build() {
    //final userModel = getUser();
    return locator<ISalesRepository>()
        .fetchSales(ref.watch(getCurrentBusinessProvider)!.id!);
  }
}
