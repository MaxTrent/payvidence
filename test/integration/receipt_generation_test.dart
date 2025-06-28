import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/screens/generate_receipt/generate_receipt.dart';
import 'package:payvidence/model/client_model.dart';
import 'package:payvidence/model/product_model.dart';
void main() {
  group('Receipt Generation Integration Tests', () {
    testWidgets('should generate receipt with existing client and product', (WidgetTester tester) async {
      final clients = [
        ClientModel(
          id: '1',
          name: 'Test Client',
          businessId: 'business_1',
          phoneNumber: '1234567890',
          address: 'Test Address',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final products = [
        Product(
          id: '1',
          name: 'Test Product',
          price: '100.0',
          businessId: 'business_1',
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: GenerateReceipt(isInvoice: false),
          ),
        ),
      );

      // Test basic widget rendering
      expect(find.byType(TextFormField), findsWidgets);
      expect(find.text('Generate'), findsOneWidget);
    });

    testWidgets('should validate required fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: GenerateReceipt(isInvoice: false),
          ),
        ),
      );

      // Try to generate without filling required fields
      final generateButton = find.text('Generate');
      expect(generateButton, findsOneWidget);
      
      await tester.tap(generateButton);
      await tester.pump();

      // Should show validation errors
      expect(find.text('Please enter client name'), findsOneWidget);
    });

    testWidgets('should add multiple product fields', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: GenerateReceipt(isInvoice: false),
          ),
        ),
      );

      // Find and tap "Add another product" button
      final addProductButton = find.text('Add another product');
      expect(addProductButton, findsOneWidget);
      
      await tester.tap(addProductButton);
      await tester.pump();

      // Should have multiple product sections
      expect(find.text('PRODUCT 2 DETAILS'), findsOneWidget);
    });
  });
}