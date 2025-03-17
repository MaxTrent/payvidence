import 'package:flutter/material.dart';

import '../utilities/enum.dart';

class DialogHandler {
  void showCustomTopToastDialog({
    required BuildContext context,
    required String message,
    required ToastMessageType toastMessageType,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: toastMessageType == ToastMessageType.failure
            ? Colors.red
            : toastMessageType == ToastMessageType.success
            ? Colors.green
            : Colors.blue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}