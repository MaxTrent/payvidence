import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final SharedPreferences sharedPreferences;

  SessionManager({required this.sharedPreferences});

  Future<void> clear() async {
    await sharedPreferences.clear();
  }

  T? get<T>(String key) {
    try {
      switch (T) {
        case String:
          return sharedPreferences.getString(key) as T?;
        case double:
          return sharedPreferences.getDouble(key) as T?;
        case bool:
          return sharedPreferences.getBool(key) as T?;
        case int:
          return sharedPreferences.getInt(key) as T?;
        case Map:
          return json.decode(sharedPreferences.getString(key)!) as T?;
        default:
          return null;
      }
    } catch (e) {
      // handle exception
      return null;
    }
  }

  Future<void> save<T>({required String key, required T value}) async {
    switch (T) {
      case String:
        await sharedPreferences.setString(key, value as String);
        break;
      case double:
        await sharedPreferences.setDouble(key, value as double);
        break;
      case bool:
        await sharedPreferences.setBool(key, value as bool);
        break;
      case int:
        await sharedPreferences.setInt(key, value as int);
        break;
      case const (List<String>):
        await sharedPreferences.setStringList(key, value as List<String>);
        break;
      case Map:
        await sharedPreferences.setString(key, json.encode(value));
        break;
    }
  }
}
