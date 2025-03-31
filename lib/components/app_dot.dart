import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_colors.dart';

class AppDot extends StatelessWidget {
  AppDot({
    this.color = appGrey4,
    super.key,
  });

  Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      width: 6.h,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(24.r)),
    );
  }
}
