import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_colors.dart';
import '../utilities/theme_mode.dart';


class AppTextField extends HookWidget {
  const AppTextField({
    required this.hintText,
    required this.controller,
    this.fillColor,
    this.suffixIcon,
    this.prefixIcon,
    this.filled,
    this.enabled,
    this.obscureText = false,
    this.appBorderColor = borderColor,
    this.validator,
    this.height = 56,
    this.radius = 8,
    this.width,
    this.focusNode,
    this.keyboardType,
    this.inputFormatters,
    this.autofillHints,
    this.textCapitalization,
    super.key,
  });




  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? fillColor;
  final Color appBorderColor;
  final bool? filled;
  final double height;
  final double radius;
  final bool? enabled;
  final double? width;
  final bool obscureText;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final List<String>? autofillHints;
  final TextCapitalization? textCapitalization;

  @override
  Widget build(BuildContext context) {
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;


    return SizedBox(
      height: height.h,
      width: width?.w,
      child: TextFormField(
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        textInputAction: TextInputAction.next,
        autofillHints: autofillHints,
        enabled: enabled,
        controller: controller,
        cursorErrorColor: appRed,
        cursorColor: isDarkMode ? Colors.white : Colors.black,
        validator: validator,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization ?? TextCapitalization.none,
        inputFormatters: inputFormatters,
        showCursor: true,
        obscureText: obscureText,
        style: Theme.of(context).textTheme.displaySmall,
        focusNode: focusNode,
        autocorrect: false,
          enableSuggestions: false,
          onFieldSubmitted: (_) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild == null) {
              currentFocus.unfocus();
            } else {
              currentFocus.nextFocus();
            }
          },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8.h),
          filled: filled,
          fillColor: fillColor,
          hintText: hintText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          errorMaxLines: 2,
          hintStyle: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(color: hintTextColor),
          labelStyle: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontWeight: FontWeight.w400),
          errorStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
              fontWeight: FontWeight.w400,
              color: Colors.red,
              height: 0.3,
              fontSize: 12.sp),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius.r),
            borderSide: BorderSide(
              color: appBorderColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius.r),
            borderSide: BorderSide(
              color: appBorderColor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius.r),
            borderSide: BorderSide(
              color: appBorderColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius.r),
            borderSide: BorderSide(
              color: appBorderColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius.r),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius.r),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
