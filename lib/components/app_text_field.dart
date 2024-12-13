import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class AppTextField extends StatelessWidget {
  AppTextField({
    required this.hintText,
    required this.controller,
    this.fillColor,
    this.suffixIcon,
    this.prefixIcon,
    this.filled,
    this.enabled,
    this.appBorderColor = borderColor,
    this.height = 56,
    this.radius = 8,
    this.width,
    super.key,
  });

  String hintText;
TextEditingController controller;
Widget? suffixIcon;
Widget? prefixIcon;
Color? fillColor;
Color appBorderColor;
bool? filled;
double height;
double radius;
bool? enabled;
double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      width: width?.w,
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        cursorColor: Colors.black,
        showCursor: true,
        style: Theme.of(context)
            .textTheme
            .displaySmall!,
        focusNode: FocusNode(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: (height / 2.5).h, // Dynamically adjust vertical padding
            horizontal: 16.w, // Horizontal padding
          ),
          filled: filled,
          fillColor: fillColor,
          hintText: hintText,
          // labelText: labelText,
          suffixIcon: suffixIcon,

          prefixIcon: prefixIcon,

          hintStyle: Theme.of(context).textTheme.displaySmall!.copyWith(color: hintTextColor),
          labelStyle: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontWeight: FontWeight.w400),
          errorStyle: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontWeight: FontWeight.w400, color: Colors.red),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius.r),
            borderSide: BorderSide(
              color: appBorderColor,
            ),),
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
            ),),
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
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius.r),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
        ),
      ),);
  }
}
