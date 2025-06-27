import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/model/record_product_details.dart';
import 'package:payvidence/model/product_model.dart';
import 'package:payvidence/screens/all_receipts/all_receipts.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';

void main() {
  group('ReceiptTile Widget Tests', () {
    testWidgets('should display receipt information correctly', (WidgetTester tester) async {
      final product = Product(
        id: '1',
        name: 'Test Product',
        logoUrl: 'https://example.com/image.jpg',
      );

      final recordDetail = RecordProductDetail(
        id: '1',
        quantity: 2,
        total: '100.00',
        product: product,
      );

      final receipt = Receipt(
        id: '1',
        total: '100.00',
        createdAt: DateTime(2024, 1, 1),
        recordProductDetails: [recordDetail],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveWrapper(
              child: ReceiptTile(receipt: receipt),
            ),
          ),
        ),
      );

      expect(find.text('Test Product'), findsOneWidget);
      expect(find.text('2 units sold'), findsOneWidget);
      expect(find.text('100.00'), findsOneWidget);
    });

    testWidgets('should handle missing product data gracefully', (WidgetTester tester) async {
      final recordDetail = RecordProductDetail(
        id: '1',
        quantity: 1,
        total: '50.00',
        product: null,
      );

      final receipt = Receipt(
        id: '1',
        total: '50.00',
        createdAt: DateTime(2024, 1, 1),
        recordProductDetails: [recordDetail],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveWrapper(
              child: ReceiptTile(receipt: receipt),
            ),
          ),
        ),
      );

      expect(find.text(''), findsWidgets); // Empty product name
      expect(find.text('1 units sold'), findsOneWidget);
    });
  });
}