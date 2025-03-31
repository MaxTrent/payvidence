import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  static show(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        barrierColor: Colors.white70,
        barrierDismissible: false,
        builder: (context) {
          return const LoadingDialog._();
        });
  }

  const LoadingDialog._();

  @override
  Widget build(BuildContext context) {
    //TODO: Disable back button while dialog is in view
    return Dialog(
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      backgroundColor: Colors.transparent,
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        //height: 223,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: 0.45,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
