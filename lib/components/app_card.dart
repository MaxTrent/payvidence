import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payvidence/utilities/responsive.dart';
import '../constants/app_colors.dart';
import '../utilities/responsive_wrapper.dart';

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
    final responsiveData = ResponsiveInherited.of(context);

    return Column(
      children: [
        Container(
          height: responsiveData.scaleHeight(52),
          width: responsiveData.scaleWidth(54),
          decoration: BoxDecoration(
            color: appGrey3,
            borderRadius: BorderRadius.circular(responsiveData.smallRadius), // Replaces 12.r
            border: Border.all(
              color: borderGrey,
              width: responsiveData.scaleHeight(1), // Replaces 1.h
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(responsiveData.scaleHeight(14)), // Replaces 14.h
            child: SvgPicture.asset(icon),
          ),
        ),
        SizedBox(
          height: responsiveData.scaleHeight(10), // Replaces 10.h
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
            fontSize: Responsive.fontSize(context, 12), // Already optimized
          ),
        ),
      ],
    );
  }
}