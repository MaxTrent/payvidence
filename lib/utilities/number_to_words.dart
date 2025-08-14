class NumberToWords {
  static const List<String> _ones = [
    '', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine',
    'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen',
    'seventeen', 'eighteen', 'nineteen'
  ];

  static const List<String> _tens = [
    '', '', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', 'eighty', 'ninety'
  ];

  static String convert(double amount) {
    if (amount == 0) return 'zero naira only';

    int naira = amount.floor();
    int kobo = ((amount - naira) * 100).round();

    // Handle rounding to next naira
    if (kobo == 100) {
      naira += 1;
      kobo = 0;
    }

    String result = '';

    if (naira > 0) {
      result += _convertNumber(naira) + ' naira';
    }

    if (kobo > 0) {
      if (result.isNotEmpty) result += ', ';
      result += _convertNumber(kobo) + ' kobo';
    }

    return result + ' only';
  }

  static String _convertNumber(int number) {
    if (number < 20) {
      return _ones[number];
    } else if (number < 100) {
      return _tens[number ~/ 10] +
          (_ones[number % 10].isNotEmpty ? ' ' + _ones[number % 10] : '');
    } else if (number < 1000) {
      return _ones[number ~/ 100] +
          ' hundred' +
          (number % 100 != 0 ? ' and ' + _convertNumber(number % 100) : '');
    } else if (number < 1000000) {
      return _convertNumber(number ~/ 1000) +
          ' thousand' +
          (number % 1000 != 0 ? ' ' + _convertNumber(number % 1000) : '');
    } else if (number < 1000000000) {
      return _convertNumber(number ~/ 1000000) +
          ' million' +
          (number % 1000000 != 0 ? ' ' + _convertNumber(number % 1000000) : '');
    } else {
      return _convertNumber(number ~/ 1000000000) +
          ' billion' +
          (number % 1000000000 != 0 ? ' ' + _convertNumber(number % 1000000000) : '');
    }
  }
}