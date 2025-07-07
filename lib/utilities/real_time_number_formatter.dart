import 'package:flutter/services.dart';

class RealTimeNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If the new value is empty, return it as is
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters except decimal point
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');
    
    // Handle decimal point
    List<String> parts = digitsOnly.split('.');
    if (parts.length > 2) {
      // If more than one decimal point, keep only the first one
      digitsOnly = parts[0] + '.' + parts.sublist(1).join('');
    }
    
    // Split into integer and decimal parts
    parts = digitsOnly.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';
    
    // Add commas to integer part
    String formattedInteger = '';
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger += ',';
      }
      formattedInteger += integerPart[i];
    }
    
    // Combine integer and decimal parts
    String formattedText = formattedInteger;
    if (parts.length > 1) {
      formattedText += '.' + decimalPart;
    }
    
    // Calculate new cursor position
    int newCursorPosition = formattedText.length;
    
    // If the user was typing at the end, keep cursor at the end
    if (newValue.selection.baseOffset == newValue.text.length) {
      newCursorPosition = formattedText.length;
    } else {
      // Try to maintain relative cursor position
      int oldCursorPos = newValue.selection.baseOffset;
      int commasBeforeCursor = 0;
      
      // Count commas before cursor in formatted text
      for (int i = 0; i < formattedText.length && i < oldCursorPos + commasBeforeCursor; i++) {
        if (formattedText[i] == ',') {
          commasBeforeCursor++;
        }
      }
      
      newCursorPosition = (oldCursorPos + commasBeforeCursor).clamp(0, formattedText.length);
    }
    
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}