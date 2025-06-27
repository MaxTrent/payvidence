import 'package:flutter_test/flutter_test.dart';
import 'package:payvidence/model/product_model.dart';

void main() {
  group('Product Model Tests', () {
    test('should create Product from JSON correctly', () {
      final json = {
        'id': '1',
        'name': 'Test Product',
        'price': '100.0',
        'quantity_available': 10,
        'vat': '5.0',
        'business_id': 'business_1',
      };

      final product = Product.fromJson(json);

      expect(product.id, '1');
      expect(product.name, 'Test Product');
      expect(product.price, '100.0');
      expect(product.quantityAvailable, 10);
      expect(product.vat, '5.0');
      expect(product.businessId, 'business_1');
    });

    test('should convert Product to JSON correctly', () {
      final product = Product(
        id: '1',
        name: 'Test Product',
        price: '100.0',
        quantityAvailable: 10,
        vat: '5.0',
        businessId: 'business_1',
      );

      final json = product.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Test Product');
      expect(json['price'], '100.0');
      expect(json['quantity_available'], 10);
      expect(json['vat'], '5.0');
      expect(json['business_id'], 'business_1');
    });

    test('should handle null values correctly', () {
      final json = <String, dynamic>{};
      final product = Product.fromJson(json);

      expect(product.id, isNull);
      expect(product.name, isNull);
      expect(product.price, isNull);
      expect(product.quantityAvailable, isNull);
    });
  });
}