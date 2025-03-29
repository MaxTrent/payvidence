import 'dart:developer' as dev;

/// `AppLogger` ?
/// To control when logs are displayed,
/// Show users log in development and hide log in production.

class AppLogger {
  AppLogger._();

  static bool _showPrettyLogs = false;
  static bool get showPrettyLogs => _showPrettyLogs;

  static bool _showLogs = false;
  static bool get showLogs => _showLogs;

  static void setLogger({
    required bool showLogs,
    bool showPrettyLogs = false,
  }) {
    _showLogs = showLogs;
    _showPrettyLogs = showPrettyLogs;
  }

  static void print(Object? e) {
    if (_showLogs) dev.log("$e");
  }
}
