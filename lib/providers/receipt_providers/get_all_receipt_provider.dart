import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/providers/business_providers/current_business_provider.dart';
import 'package:payvidence/repositories/repository/receipt_repository.dart';
import '../../model/receipt_model.dart';
import '../../shared_dependency/shared_dependency.dart';

final getAllReceiptProvider =
    AsyncNotifierProvider<GetAllReceiptNotifier, List<Receipt>>(() {
  return GetAllReceiptNotifier();
});

class GetAllReceiptNotifier extends AsyncNotifier<List<Receipt>> {
  @override
  Future<List<Receipt>> build() {
    //final userModel = getUser();
    return locator<IReceiptRepository>().fetchAllReceipts(
        ref.watch(getCurrentBusinessProvider)!.id!, 'receipt');
  }

  Future<Receipt> addReceipt(Map<String, dynamic> data) {
    return locator<IReceiptRepository>().createReceipt(data);
  }

  Future<void> deleteDraft(String id) async {
    await locator<IReceiptRepository>().deleteReceipt(id);
  }

  Future<Receipt> updateReceipt(
      String id, Map<String, dynamic> data, bool? publish) {
    return locator<IReceiptRepository>().updateReceipt(id, data, publish);
  }

  Future<Receipt> reIssueReceipt(String id, Map<String, dynamic> data) {
    return locator<IReceiptRepository>().invoiceToReceipt(id, data);
  }
// Add methods to mutate the state
}
