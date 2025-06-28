import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:payvidence/utilities/cache_service.dart';

void main() {
  group('CacheService Tests', () {
    late CacheService cacheService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      cacheService = CacheService(prefs);
    });

    test('should set and get cache data correctly', () async {
      final testData = {'key': 'value'};
      await cacheService.set('test_key', testData);
      
      final result = cacheService.get('test_key');
      expect(result, isNotNull);
      expect(result!['key'], 'value');
    });

    test('should return null for non-existent cache', () {
      final result = cacheService.get('non_existent_key');
      expect(result, isNull);
    });

    test('should clear cache correctly', () async {
      final testData = {'key': 'value'};
      await cacheService.set('test_key', testData);
      
      await cacheService.clear('test_key');
      final result = cacheService.get('test_key');
      
      expect(result, isNull);
    });

    test('should handle cache with TTL', () async {
      final testData = {'key': 'value'};
      await cacheService.set('test_key', testData, ttlMinutes: 1);
      
      final result = cacheService.get('test_key');
      expect(result, isNotNull);
    });
  });
}