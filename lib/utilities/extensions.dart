import 'package:intl/intl.dart';

extension NumberFormatting on String {
  String commaSeparated() {
    final number = double.tryParse(this) ?? 0.0;
    final format = NumberFormat("#,##0.##", "en_US");
    return format.format(number);
  }

  String capitalize() {
    return length < 2 ? toUpperCase() : '${this[0].toUpperCase()}${substring(1)}';
  }
}
