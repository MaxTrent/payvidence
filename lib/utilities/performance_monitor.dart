import 'package:flutter/foundation.dart';
import 'app_logger.dart';

class PerformanceMonitor {
  static final Map<String, DateTime> _startTimes = {};

  static void startTimer(String operation) {
    _startTimes[operation] = DateTime.now();
  }

  static void endTimer(String operation) {
    final startTime = _startTimes[operation];
    if (startTime != null) {
      final duration = DateTime.now().difference(startTime);
      _logPerformance(operation, duration);
      _startTimes.remove(operation);
    }
  }

  static void _logPerformance(String operation, Duration duration) {
    if (kDebugMode) {
      AppLogger.print('⏱️ $operation: ${duration.inMilliseconds}ms');

      if (duration.inMilliseconds > 1000) {
        AppLogger.print('Slow operation detected: $operation');
      }
    }
  }
}
