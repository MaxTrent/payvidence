import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/product_model.dart';

void main() {
  group('Product Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should create product list correctly', () {
      final products = [
        Product(id: '1', name: 'Product 1', price: '100'),
        Product(id: '2', name: 'Product 2', price: '200'),
      ];

      expect(products.length, 2);
      expect(products.first.name, 'Product 1');
      expect(products.last.price, '200');
    });

    test('should handle product filtering', () {
      final products = [
        Product(id: '1', name: 'Apple iPhone', price: '1000'),
        Product(id: '2', name: 'Samsung Galaxy', price: '800'),
        Product(id: '3', name: 'Apple iPad', price: '600'),
      ];

      final appleProducts = products.where((p) => p.name!.contains('Apple')).toList();
      expect(appleProducts.length, 2);
    });

    test('should handle product quantity calculations', () {
      final product = Product(id: '1', name: 'Product 1', quantityAvailable: 10, quantitySold: 5);
      
      final totalHandled = (product.quantityAvailable ?? 0) + (product.quantitySold ?? 0);
      expect(totalHandled, 15);
    });
  });
}