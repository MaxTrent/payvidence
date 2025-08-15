import 'package:flutter_test/flutter_test.dart';
import 'package:payvidence/model/plan_model.dart';

void main() {
  group('Plan Model Tests', () {
    test('should parse plan with unlimited values correctly', () {
      final json = {
        "id": "test-id",
        "name": "Test Plan",
        "business_accounts_allowed": 5,
        "invoice_generation_per_month": "unlimited",
        "receipt_generation_per_month": "unlimited",
        "sales_report": true,
        "receipt_sharing": true,
        "receipt_printing": true,
        "inventory_management": true,
        "pdf_csv_export": true,
        "client_management": true,
        "brand_management": true,
        "letterhead_transaction": true,
        "payment_instructions": true,
        "advanced_reporting_and_analytics": true,
        "templates": 0,
        "is_recommended": true,
        "duration": "yearly",
        "amount": "60000.00",
        "created_at": "2025-02-25T10:31:43.000000Z",
        "updated_at": "2025-02-25T10:31:43.000000Z"
      };

      final plan = Plan.fromJson(json);

      expect(plan.id, equals("test-id"));
      expect(plan.name, equals("Test Plan"));
      expect(plan.invoiceGenerationPerMonth, isNull);
      expect(plan.receiptGenerationPerMonth, isNull);
      expect(plan.hasUnlimitedInvoices, isTrue);
      expect(plan.hasUnlimitedReceipts, isTrue);
      expect(plan.invoiceGenerationDisplay, equals("Unlimited"));
      expect(plan.receiptGenerationDisplay, equals("Unlimited"));
    });

    test('should parse plan with numeric values correctly', () {
      final json = {
        "id": "test-id-2",
        "name": "Free Plan",
        "business_accounts_allowed": 1,
        "invoice_generation_per_month": "15",
        "receipt_generation_per_month": "30",
        "sales_report": false,
        "receipt_sharing": true,
        "receipt_printing": true,
        "inventory_management": false,
        "pdf_csv_export": false,
        "client_management": false,
        "brand_management": false,
        "letterhead_transaction": false,
        "payment_instructions": true,
        "advanced_reporting_and_analytics": false,
        "templates": 0,
        "is_recommended": false,
        "duration": "yearly",
        "amount": "0.00",
        "created_at": "2025-08-14T07:26:43.000000Z",
        "updated_at": "2025-08-14T07:26:43.000000Z"
      };

      final plan = Plan.fromJson(json);

      expect(plan.id, equals("test-id-2"));
      expect(plan.name, equals("Free Plan"));
      expect(plan.invoiceGenerationPerMonth, equals(15));
      expect(plan.receiptGenerationPerMonth, equals(30));
      expect(plan.hasUnlimitedInvoices, isFalse);
      expect(plan.hasUnlimitedReceipts, isFalse);
      expect(plan.invoiceGenerationDisplay, equals("15"));
      expect(plan.receiptGenerationDisplay, equals("30"));
    });

    test('should handle edge cases gracefully', () {
      final json = {
        "id": "test-id-3",
        "name": "Edge Case Plan",
        "business_accounts_allowed": 1,
        "invoice_generation_per_month": "",
        "receipt_generation_per_month": null,
        "sales_report": false,
        "receipt_sharing": true,
        "receipt_printing": true,
        "inventory_management": false,
        "pdf_csv_export": false,
        "client_management": false,
        "brand_management": false,
        "letterhead_transaction": false,
        "payment_instructions": true,
        "advanced_reporting_and_analytics": false,
        "templates": 0,
        "is_recommended": false,
        "duration": "yearly",
        "amount": "0.00",
        "created_at": "2025-08-14T07:26:43.000000Z",
        "updated_at": "2025-08-14T07:26:43.000000Z"
      };

      final plan = Plan.fromJson(json);

      expect(plan.invoiceGenerationPerMonth, isNull);
      expect(plan.receiptGenerationPerMonth, isNull);
      expect(plan.invoiceGenerationDisplay, equals("Unlimited"));
      expect(plan.receiptGenerationDisplay, equals("Unlimited"));
    });
  });
}