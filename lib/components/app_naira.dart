import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppNaira extends StatelessWidget {
  const AppNaira({
    super.key,
    required this.fontSize
  });

  final int fontSize;

  @override
  Widget build(BuildContext context) {
    return Text('\u20A6',style: TextStyle(
      fontSize: fontSize.sp,
      fontFamily: 'Roboto'
    ),);
  }
}