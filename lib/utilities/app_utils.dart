import 'package:flutter/foundation.dart';

class AppUtils{
  static void debug(String msg) {
    if (kDebugMode) {
      print(msg);
    }
  }
}