import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/components/loading_indicator.dart';

import '../constants/app_colors.dart';

class AppButton extends StatelessWidget {
  AppButton({
    required this.buttonText,
    required this.onPressed,
    this.height,
    this.width,
    this.backgroundColor = primaryColor2,
    this.textColor = Colors.white,
    this.isProcessing = false,
    this.isDisabled = false,
    super.key,
  });

  String buttonText;
  void Function()? onPressed;
  double? height;
  double? width;
  Color backgroundColor;
  Color textColor;
  final bool isProcessing;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 56.h,
      width: width?.w,
      child: ElevatedButton(
        onPressed: isProcessing || isDisabled ? null : onPressed,
        style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(isDisabled? Colors.grey: backgroundColor),
            foregroundColor: WidgetStateProperty.all(textColor),
            elevation: WidgetStateProperty.all(0),
            minimumSize: WidgetStateProperty.all(Size(350.w, 60.h)),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(40.r),
              ),
            )),
        child: isProcessing
            ? const LoadingIndicator(color: Colors.white,)
            : Text(
                buttonText,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(fontWeight: FontWeight.w600, color: textColor),
              ),
      ),
    );
  }
}
