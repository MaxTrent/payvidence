import 'package:flutter/material.dart';
import 'package:payvidence/components/loading_indicator.dart';
import '../constants/app_colors.dart';
import '../utilities/responsive_wrapper.dart';

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

    return SizedBox(
      height: dynamicHeight,
      width: dynamicWidth,
      child: ElevatedButton(
        onPressed: isProcessing || isDisabled ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            isDisabled ? const Color.fromRGBO(78, 56, 178, 0.4) : backgroundColor,
          ),
          foregroundColor: WidgetStateProperty.all(textColor),
          elevation: WidgetStateProperty.all(0),
          minimumSize: WidgetStateProperty.all(
            Size(
              responsiveData.minButtonWidth,
              responsiveData.minButtonHeight,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(responsiveData.radius),
            ),
          ),
        ),
        child: isProcessing
            ? const LoadingIndicator(
          color: Colors.white,
        )
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