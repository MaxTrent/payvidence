import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:payvidence/data/network/network_service.dart';
import 'package:payvidence/data/network/api_response.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  group('NetworkService Tests', () {
    late NetworkService networkService;
    late Dio dio;

    setUp(() {
      dio = Dio();
      networkService = NetworkService(dio: dio, baseUrl: 'https://test.api.com');
    });

    test('should initialize network service correctly', () {
      expect(networkService.baseUrl, 'https://test.api.com');
      expect(networkService.dio, isNotNull);
    });

    test('should create dio instance correctly', () {
      expect(networkService.dio, isA<Dio>());
    });

    test('should handle base URL correctly', () {
      final service = NetworkService(dio: Dio(), baseUrl: 'https://api.example.com');
      expect(service.baseUrl, 'https://api.example.com');
    });
  });
}