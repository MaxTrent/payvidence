import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  final SharedPreferences _prefs;
  static const int _defaultTtlMinutes = 30;

  CacheService(this._prefs);

  Future<void> set(String key, Map<String, dynamic> data, {int? ttlMinutes}) async {
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'ttl': (ttlMinutes ?? _defaultTtlMinutes) * 60 * 1000,
    };
    await _prefs.setString('cache_$key', jsonEncode(cacheData));
  }

  Map<String, dynamic>? get(String key) {
    final cached = _prefs.getString('cache_$key');
    if (cached == null) return null;

    final cacheData = jsonDecode(cached);
    final timestamp = cacheData['timestamp'] as int;
    final ttl = cacheData['ttl'] as int;

    if (DateTime.now().millisecondsSinceEpoch - timestamp > ttl) {
      _prefs.remove('cache_$key');
      return null;
    }

    return cacheData['data'] as Map<String, dynamic>;
  }

  Future<void> clear(String key) async {
    await _prefs.remove('cache_$key');
  }
}
