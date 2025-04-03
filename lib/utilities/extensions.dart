import 'package:intl/intl.dart';


// extension NumberFormatting on String {
//   String toCommaSeparated() {
//     final numberStr = toString();
//     final buffer = StringBuffer();
//     int count = 0;
//
//     for (int i = numberStr.length - 1; i >= 0; i--) {
//       buffer.write(numberStr[i]);
//       count++;
//       if (count % 3 == 0 && i != 0) {
//         buffer.write(',');
//       }
//     }
//
//     return buffer.toString().split('').reversed.join('');
//   }
// }

extension StringFormatting on String {
  String capitalize() {
    return isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
  }
}

extension NumberFormatting on String {
  String commaSeparated() {
    final number = double.tryParse(this) ?? 0.0;
    final format = NumberFormat("#,##0.##", "en_US");
    return format.format(number);
  }

  String toCommaSeparated({String locale = 'en_US'}) {
    int? number = int.tryParse(this);

    if (number == null) {
      double? doubleNumber = double.tryParse(this);
      if (doubleNumber == null) {
        return this;
      } else {
        final formatter = NumberFormat.decimalPattern(locale);
        return formatter.format(doubleNumber);
      }
    } else {
      final formatter = NumberFormat.decimalPattern(locale);
      return formatter.format(number);
    }
  }
}

extension DateTimeFormatting on DateTime? {
  String toFormattedString() {
    if (this == null) return "";
    return DateFormat('MMMM d, yyyy').format(this!);
  }
}


extension StringNumberFormatting on String {
  String toKMB() {
    final numValue = num.tryParse(this);

    if (numValue == null || numValue < 0) {
      return this;
    }

    if (numValue >= 1000000) {
      return '${(numValue / 1000000).toStringAsFixed(0)}M';
    } else if (numValue >= 1000) {
      return '${(numValue / 1000).toStringAsFixed(0)}K';
    } else {
      return numValue.toStringAsFixed(0);
    }
  }
}

extension StringDateFormatting on String? {
  String toFormattedIsoDate() {
    if (this == null || this!.isEmpty) return "";
    try {
      final dateTime = DateTime.parse(this!);
      return dateTime.toFormattedString();
    } catch (e) {
      print("Error parsing date: $e");
      return this!;
    }
  }
}
