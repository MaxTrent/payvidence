import 'dart:convert';
import 'package:payvidence/data/local/session_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final SharedPreferences sharedPreferences;

  SessionManager({required this.sharedPreferences});

  Future<void> clear() async {
    await sharedPreferences.remove(SessionConstants.isUserLoggedIn);
    await sharedPreferences.remove(SessionConstants.accessTokenPref);
    await sharedPreferences.remove(SessionConstants.businessId);
    await sharedPreferences.remove(SessionConstants.userId);
    await sharedPreferences.remove(SessionConstants.userEmail);
    print("SharedPreferences cleared");
  }

  T? get<T>(String key) {
    try {
      switch (T) {
        case String:
          final value = sharedPreferences.getString(key);
          print("Get: key='$key', value='$value'");
          return value as T?;
        case double:
          return sharedPreferences.getDouble(key) as T?;
        case bool:
          return sharedPreferences.getBool(key) as T?;
        case int:
          return sharedPreferences.getInt(key) as T?;
        case Map:
          final stringValue = sharedPreferences.getString(key);
          return stringValue != null ? json.decode(stringValue) as T? : null;
        default:
          return null;
      }
    } catch (e) {
      print("Error getting key='$key': $e");
      return null;
    }
  }

  Future<void> save<T>({required String key, required T value}) async {
    try {
      switch (T) {
        case String:
          await sharedPreferences.setString(key, value as String);
          print("Saved: key='$key', value='$value'");
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
    } catch (e) {
      print("Error saving key='$key': $e");
    }
  }
}