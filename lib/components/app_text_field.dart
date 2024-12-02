import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class AppTextField extends StatelessWidget {
  AppTextField({
    required this.hintText,
    required this.controller,
    this.suffixIcon,
    super.key,
  });

  String hintText;
TextEditingController controller;
Widget? suffixIcon;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      child: TextFormField(
        controller: controller,
        cursorColor: Colors.black,
        showCursor: true,
        style: Theme.of(context)
            .textTheme
            .displaySmall!,
        focusNode: FocusNode(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8.h),
          // filled: filled,
          // fillColor: fillColor,
          hintText: hintText,
          // labelText: labelText,
          suffixIcon: suffixIcon,

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
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              color: borderColor,
            ),),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              color: borderColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              color: borderColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
        ),
      ),);
  }
}
