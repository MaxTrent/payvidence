import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';

class AppCard extends StatelessWidget {
  AppCard({
    required this.text,
    required this.icon,
    super.key,
  });

  String icon;
  String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 52.h,
          width: 54.w,
          decoration: BoxDecoration(
            color: appGrey3,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: borderGrey, width: 1.h),
          ),
          child: Padding(
            padding: EdgeInsets.all(14.h),
            child: SvgPicture.asset(icon),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(fontSize: 12.sp),
        )
      ],
    );
  }
}
