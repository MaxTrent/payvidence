import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';


class ToastService {
  ToastService._();

  static void success(context, String msg, {int? seconds}) {
    toastification.show(
      context: context,
      backgroundColor: Colors.green,
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
      title: Text(
        msg,
        style: TextStyle(color: Colors.white,),

        overflow: TextOverflow.clip,
      ),
      showProgressBar: false,
      autoCloseDuration: Duration(seconds: seconds ?? 5),
    );
  }

  static void error(context, String msg, {int? seconds}) {
    toastification.show(
      context: context,
      backgroundColor: Colors.redAccent,
      icon: const Icon(
        Icons.info_outline,
        color: Colors.white,
      ),
      title: Text(
        msg,
        style: TextStyle(color: Colors.white,),

        overflow: TextOverflow.clip,
      ),
      showProgressBar: false,
      autoCloseDuration: Duration(seconds: seconds ?? 5),
    );
  }
}