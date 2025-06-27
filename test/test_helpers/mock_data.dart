import 'package:payvidence/model/product_model.dart';
import 'package:payvidence/model/client_model.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/model/record_product_details.dart';
import 'package:payvidence/model/business_model.dart';

class MockData {
  static Product createMockProduct({
    String id = '1',
    String name = 'Test Product',
    String price = '100.0',
    int quantityAvailable = 10,
    String vat = '0',
  }) {
    return Product(
      id: id,
      name: name,
      price: price,
      quantityAvailable: quantityAvailable,
      vat: vat,
      businessId: 'business_1',
    );
  }

  static ClientModel createMockClient({
    String id = '1',
    String name = 'Test Client',
    String businessId = 'business_1',
  }) {
    return ClientModel(
      id: id,
      name: name,
      businessId: businessId,
      phoneNumber: '1234567890',
      address: 'Test Address',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Receipt createMockReceipt({
    String id = '1',
    String total = '100.0',
    List<RecordProductDetail>? recordProductDetails,
  }) {
    return Receipt(
      id: id,
      total: total,
      clientId: 'client_1',
      businessId: 'business_1',
      status: 'completed',
      modeOfPayment: 'cash',
      createdAt: DateTime.now(),
      recordProductDetails: recordProductDetails ?? [createMockRecordProductDetail()],
    );
  }

  static RecordProductDetail createMockRecordProductDetail({
    String id = '1',
    int quantity = 2,
    String total = '100.0',
    Product? product,
  }) {
    return RecordProductDetail(
      id: id,
      quantity: quantity,
      total: total,
      price: '50.0',
      discount: '0',
      product: product ?? createMockProduct(),
    );
  }

  static Map<String, dynamic> createMockApiResponse({
    bool success = true,
    dynamic data,
    String? message,
  }) {
    return {
      'success': success,
      'message': message ?? (success ? 'Success' : 'Error'),
      'data': data,
    };
  }
}