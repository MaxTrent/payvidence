import 'package:flutter_test/flutter_test.dart';
import 'package:payvidence/model/receipt_model.dart';

void main() {
  group('Receipt Model Tests', () {
    test('should create Receipt from JSON correctly', () {
      final json = {
        'id': '1',
        'client_id': 'client_1',
        'business_id': 'business_1',
        'total': '100.0',
        'status': 'completed',
        'mode_of_payment': 'cash',
        'record_product_details': [],
      };

      final receipt = Receipt.fromJson(json);

      expect(receipt.id, '1');
      expect(receipt.clientId, 'client_1');
      expect(receipt.businessId, 'business_1');
      expect(receipt.total, '100.0');
      expect(receipt.status, 'completed');
      expect(receipt.modeOfPayment, 'cash');
      expect(receipt.recordProductDetails, isEmpty);
    });

    test('should convert Receipt to JSON correctly', () {
      final receipt = Receipt(
        id: '1',
        clientId: 'client_1',
        businessId: 'business_1',
        total: '100.0',
        status: 'completed',
        modeOfPayment: 'cash',
        recordProductDetails: [],
      );

      final json = receipt.toJson();

      expect(json['id'], '1');
      expect(json['client_id'], 'client_1');
      expect(json['business_id'], 'business_1');
      expect(json['total'], '100.0');
      expect(json['status'], 'completed');
      expect(json['mode_of_payment'], 'cash');
    });
  });
}