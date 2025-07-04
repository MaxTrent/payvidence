import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../utilities/enum.dart';

class DialogHandler {
  void showCustomTopToastDiaprint({
    required BuildContext context,
    required String message,
    required ToastMessageType toastMessageType,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: toastMessageType == ToastMessageType.failure
            ? appRed
            : toastMessageType == ToastMessageType.success
                ? Colors.green
                : Colors.blue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
