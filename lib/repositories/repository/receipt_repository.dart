import 'package:dio/dio.dart';
import 'package:payvidence/datasource/data/product_datasource.dart';
import 'package:payvidence/model/product_model.dart';

import '../../datasource/data/receipt_datasource.dart';
import '../../model/receipt_model.dart';

abstract class IReceiptRepository {
  Future<Receipt> createReceipt(Map<String, dynamic> requestData);

  Future<List<Receipt>> fetchAllReceipts(String businessId, String? recordType);

  Future<void> deleteReceipt(String receiptId);
}

class ReceiptRepository extends IReceiptRepository {
  final IReceiptDatasource receiptDatasource;

  ReceiptRepository(this.receiptDatasource);

  @override
  Future<Receipt> createReceipt(Map<String, dynamic> requestData) {
    return receiptDatasource.createReceipt(requestData);
  }

  @override
  Future<List<Receipt>> fetchAllReceipts(String businessId, String? recordType) {
    return receiptDatasource.fetchAllReceipts(businessId, recordType);
  }

  @override
  Future<void> deleteReceipt(String receiptId) {
    return receiptDatasource.deleteReceipt(receiptId);

  }
}
