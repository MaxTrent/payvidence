import 'package:flutter/material.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:toastification/toastification.dart';


class ToastService {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  ToastService._();

  static void showSnackBar(String message) {
    final context = scaffoldMessengerKey.currentContext;
    if (context == null) return; // Ensure context is not null

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Polysans',
            color: Colors.white,
            fontSize: Responsive.fontSize(context, 16),
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: primaryColor2,
      ),
    );
  }

  static void showErrorSnackBar(String message) {
    final context = scaffoldMessengerKey.currentContext;
    if (context == null) return;

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Polysans',
            color: Colors.white,
            fontSize: Responsive.fontSize(context, 16),
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: appRed,
      ),
    );
  }

  static void success(String msg, {int? seconds}) {
    final context = scaffoldMessengerKey.currentContext;
    if (context == null) return;

    toastification.show(
      backgroundColor: Colors.green,
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
      title: Text(
        msg,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
          color: Colors.white,
        ),
        overflow: TextOverflow.clip,
      ),
      showProgressBar: false,
      autoCloseDuration: Duration(seconds: seconds ?? 5),
    );
  }

  static void error(String msg, {int? seconds}) {
    final context = scaffoldMessengerKey.currentContext;
    if (context == null) return;

    toastification.show(
      backgroundColor: appRed,
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
      title: Text(
        msg,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(
          color: Colors.white,
        ),
        overflow: TextOverflow.clip,
      ),
      showProgressBar: false,
      autoCloseDuration: Duration(seconds: seconds ?? 5),
    );
  }

  static void info(BuildContext context, String msg, {int? seconds}) {
    toastification.show(
      context: context,
      backgroundColor: Colors.blue,
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
      title: Text(
        msg,
        style: TextStyle(
          color: Colors.white,
          fontSize: Responsive.fontSize(context, 16),
          fontFamily: 'Polysans',
          fontWeight: FontWeight.w400,
        ),
        overflow: TextOverflow.clip,
      ),
      showProgressBar: false,
      autoCloseDuration: Duration(seconds: seconds ?? 5),
    );
  }
}