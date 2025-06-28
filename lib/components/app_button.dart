import 'package:flutter/material.dart';
import 'package:payvidence/components/loading_indicator.dart';
import '../constants/app_colors.dart';
import '../utilities/responsive_wrapper.dart';
import '../utilities/animations.dart';

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
    final responsiveData = ResponsiveInherited.of(context);
    final dynamicHeight = height != null ? responsiveData.scaleHeight(height!) : responsiveData.scaleHeight(56);
    final dynamicWidth = width != null ? responsiveData.scaleWidth(width!) : null;

    return AnimatedPressButton(
      onPressed: isProcessing || isDisabled ? null : onPressed,
      child: Container(
        height: dynamicHeight,
        width: dynamicWidth,
        decoration: BoxDecoration(
          color: isDisabled ? const Color.fromRGBO(78, 56, 178, 0.4) : backgroundColor,
          borderRadius: BorderRadius.circular(responsiveData.radius),
        ),
        child: Center(
          child: isProcessing
              ? const LoadingIndicator(color: Colors.white)
              : Text(
                  buttonText,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontWeight: FontWeight.w600, color: textColor),
                ),
        ),
      ),
    );
  }
}