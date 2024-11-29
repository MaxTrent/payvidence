import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';

class AppButton extends StatelessWidget {
  AppButton({
    required this.buttonText,
    required this.onPressed,
    super.key,
  });

  String buttonText;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        buttonText,
        style: Theme.of(context)
            .textTheme
            .displayMedium!
            .copyWith(
            fontWeight: FontWeight.w600,
            color: scaffoldBackground),
      ),
      style: ButtonStyle(
          backgroundColor:
          WidgetStateProperty.all(primaryColor2),
          foregroundColor:
          WidgetStateProperty.all(Colors.white),
          minimumSize:
          WidgetStateProperty.all(Size(350.w, 60.h)),
          shape:
          WidgetStateProperty.all(RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(40.r),
          ))),
    );
  }
}
