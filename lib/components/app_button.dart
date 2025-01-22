import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class AppButton extends StatelessWidget {
  AppButton({
    required this.buttonText,
    required this.onPressed,
    this.height,
    this.backgroundColor = primaryColor2,
    this.textColor = Colors.white,
    super.key,
  });

  String buttonText;
  void Function()? onPressed;
  double? height;
  Color backgroundColor;
  Color textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 56.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
            backgroundColor:
            WidgetStateProperty.all(backgroundColor),
            foregroundColor:
            WidgetStateProperty.all(textColor),
            elevation: WidgetStateProperty.all(0),
            minimumSize:
            WidgetStateProperty.all(Size(350.w, 60.h)),
            shape:
            WidgetStateProperty.all(RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(40.r),
            ),

            )),
        child: Text(
          buttonText,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(
              fontWeight: FontWeight.w600,
              color: textColor),
        ),
      ),
    );
  }
}
