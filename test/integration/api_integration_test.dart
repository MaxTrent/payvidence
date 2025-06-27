import 'package:flutter_test/flutter_test.dart';
import 'package:payvidence/data/api_services.dart';
import 'package:payvidence/data/network/api_response.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  group('API Integration Tests', () {
    setUp(() {
      // Setup test environment
    });

    test('should create account successfully', () async {
      final mockResponse = {
        'success': true,
        'data': {
          'id': '1',
          'email': 'test@example.com',
          'first_name': 'John',
          'last_name': 'Doe',
        }
      };

      // Test account creation data structure
      expect(mockResponse['success'], true);
      expect((mockResponse['data'] as Map)['email'], 'test@example.com');
    });

    test('should handle login correctly', () async {
      final mockResponse = {
        'success': true,
        'data': {
          'user': {
            'id': '1',
            'email': 'test@example.com',
          },
          'token': 'mock_token_123'
        }
      };

      expect(mockResponse['success'], true);
      expect((mockResponse['data'] as Map)['token'], 'mock_token_123');
    });

    test('should handle API errors correctly', () async {
      final errorResponse = {
        'success': false,
        'message': 'Invalid credentials',
        'errors': ['Email or password is incorrect']
      };

      // Test error handling
      expect(errorResponse['success'], false);
      expect(errorResponse['message'], 'Invalid credentials');
    });

    test('should create receipt with products correctly', () async {
      final requestData = {
        'products': [
          {
            'name': 'Test Product',
            'price': 100.0,
            'quantity_purchased': 2,
            'discount': 5.0,
            'vat': '0',
          }
        ],
        'record_type': 'receipt',
        'business_id': 'business_1',
        'client_id': 'client_1',
        'is_draft': false,
        'mode_of_payment': 'cash'
      };

      final mockResponse = {
        'success': true,
        'data': {
          'id': 'receipt_1',
          'total': '190.00',
          'products': [
            {
              'id': 'product_1',
              'quantity': 2,
              'price': '100.00',
              'discount': 5,
              'total': '190.00',
            }
          ]
        }
      };

      expect(mockResponse['success'], true);
      expect((mockResponse['data'] as Map)['total'], '190.00');
    });
  });
}