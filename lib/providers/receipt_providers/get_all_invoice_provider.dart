import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/product_model.dart';
import 'package:payvidence/providers/business_providers/current_business_provider.dart';
import 'package:payvidence/providers/product_providers/product_fillter_provider.dart';
import 'package:payvidence/repositories/repository/product_repository.dart';
import 'package:payvidence/repositories/repository/receipt_repository.dart';
import '../../model/receipt_model.dart';
import '../../shared_dependency/shared_dependency.dart';

final getAllInvoiceProvider =
    AsyncNotifierProvider<GetAllInvoiceNotifier, List<Receipt>>(() {
  return GetAllInvoiceNotifier();
});

class GetAllInvoiceNotifier extends AsyncNotifier<List<Receipt>> {
  @override
  Future<List<Receipt>> build() {
    //final userModel = getUser();
    return locator<IReceiptRepository>()
        .fetchAllReceipts(ref.read(getCurrentBusinessProvider)!.id!, 'invoice');
  }

  Future<Receipt> addInvoice(Map<String, dynamic> data) {
    return locator<IReceiptRepository>().createReceipt(data);
  }
// Add methods to mutate the state
}
