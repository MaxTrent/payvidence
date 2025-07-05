import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/providers/business_providers/current_business_provider.dart';
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
    final currentBusiness = ref.read(getCurrentBusinessProvider);
    if (currentBusiness?.id == null) {
      return Future.value([]);
    }
    return locator<IReceiptRepository>()
        .fetchAllReceipts(currentBusiness!.id!, 'invoice');
  }

  Future<Receipt> addInvoice(Map<String, dynamic> data) {
    return locator<IReceiptRepository>().createReceipt(data);
  }

  Future<void> deleteDraft(String id) async {
    await locator<IReceiptRepository>().deleteReceipt(id);
  }

  Future<void> refreshInvoices(String businessId) async {
    state = const AsyncLoading();
    try {
      final invoices = await locator<IReceiptRepository>().fetchAllReceipts(businessId, 'invoice');
      state = AsyncData(invoices);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
// Add methods to mutate the state
}
