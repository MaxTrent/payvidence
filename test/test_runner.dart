import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'unit/models/product_model_test.dart' as product_model_tests;
import 'unit/models/receipt_model_test.dart' as receipt_model_tests;
import 'unit/services/network_service_test.dart' as network_service_tests;
import 'unit/providers/product_provider_test.dart' as product_provider_tests;
import 'unit/utilities/performance_monitor_test.dart' as performance_monitor_tests;
import 'widget/receipt_tile_test.dart' as receipt_tile_tests;
import 'integration/receipt_generation_test.dart' as receipt_generation_tests;
import 'integration/api_integration_test.dart' as api_integration_tests;

void main() {
  group('All Tests', () {
    group('Unit Tests', () {
      group('Models', () {
        product_model_tests.main();
        receipt_model_tests.main();
      });

      group('Services', () {
        network_service_tests.main();
      });

      group('Providers', () {
        product_provider_tests.main();
      });

      group('Utilities', () {
        performance_monitor_tests.main();
      });
    });

    group('Widget Tests', () {
      receipt_tile_tests.main();
    });

    group('Integration Tests', () {
      receipt_generation_tests.main();
      api_integration_tests.main();
    });
  });
}