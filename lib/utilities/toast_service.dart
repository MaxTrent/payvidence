import 'package:flutter/material.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:toastification/toastification.dart';


class ToastService {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  ToastService._();

  static void success(String msg, {int? seconds}) {
    final context = scaffoldMessengerKey.currentContext;
    toastification.show(
      backgroundColor: Colors.green,
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
      title: Text(
        msg,
        style: Theme.of(context!).textTheme.displaySmall?.copyWith(color: Colors.white,),
        overflow: TextOverflow.clip,
      ),
      showProgressBar: false,
      autoCloseDuration: Duration(seconds: seconds ?? 5),
    );
  }

  static void error(String msg, {int? seconds}) {
    final context = scaffoldMessengerKey.currentContext;
    toastification.show(
      backgroundColor: appRed,
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
      title: Text(
        msg,
        style: Theme.of(context!).textTheme.displaySmall?.copyWith(color: Colors.white,),

        overflow: TextOverflow.clip,
      ),
      showProgressBar: false,
      autoCloseDuration: Duration(seconds: seconds ?? 5),
    );
  }
  static void info(context, String msg, {int? seconds}) {
    toastification.show(
      context: context,
      backgroundColor: Colors.blue,
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
      title: Text(
        msg,
        style: const TextStyle(color: Colors.white,),

        overflow: TextOverflow.clip,
      ),
      showProgressBar: false,
      autoCloseDuration: Duration(seconds: seconds ?? 5),
    );
  }
}