import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class AppTextField extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      width: width?.w,
      child: TextFormField(
        onTapOutside: (event){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        enabled: enabled,
        controller: controller,
        cursorColor: Colors.black,
        validator: validator,
        keyboardType: keyboardType,
        showCursor: true,
        obscureText: obscureText,
        style: Theme.of(context)
            .textTheme
            .displaySmall!,
        focusNode: focusNode,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8.h),
          filled: filled,
          fillColor: fillColor,
          hintText: hintText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          errorMaxLines: 2,
          // isDense: true,
          // helperText: '',
          hintStyle: Theme.of(context).textTheme.displaySmall!.copyWith(color: hintTextColor),
          labelStyle: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontWeight: FontWeight.w400,),
          errorStyle: Theme.of(context)
              .textTheme
              .displaySmall!
              .copyWith(fontWeight: FontWeight.w400, color: Colors.red, height: 0.3, fontSize: 12.sp),
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
      ),);
  }
}
