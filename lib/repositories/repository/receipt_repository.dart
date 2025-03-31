import '../../datasource/data/receipt_datasource.dart';
import '../../model/receipt_model.dart';

abstract class IReceiptRepository {
  Future<Receipt> createReceipt(Map<String, dynamic> requestData);

  Future<List<Receipt>> fetchAllReceipts(String businessId, String? recordType);

  Future<void> deleteReceipt(String receiptId);

  Future<Receipt> updateReceipt(
      String recordId, Map<String, dynamic> requestData, bool? publish);

  Future<Receipt> invoiceToReceipt(
      String recordId, Map<String, dynamic> requestData);
}

class ReceiptRepository extends IReceiptRepository {
  final IReceiptDatasource receiptDatasource;

  ReceiptRepository(this.receiptDatasource);

  @override
  Future<Receipt> createReceipt(Map<String, dynamic> requestData) {
    return receiptDatasource.createReceipt(requestData);
  }

  @override
  Future<List<Receipt>> fetchAllReceipts(
      String businessId, String? recordType) {
    return receiptDatasource.fetchAllReceipts(businessId, recordType);
  }

  @override
  Future<void> deleteReceipt(String receiptId) {
    return receiptDatasource.deleteReceipt(receiptId);
  }

  @override
  Future<Receipt> updateReceipt(
      String recordId, Map<String, dynamic> requestData, bool? publish) {
    return receiptDatasource.updateReceipt(recordId, requestData, publish);
  }

  @override
  Future<Receipt> invoiceToReceipt(
      String recordId, Map<String, dynamic> requestData) {
    return receiptDatasource.invoiceToReceipt(recordId, requestData);
  }
}
