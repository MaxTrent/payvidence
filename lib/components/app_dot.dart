import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utilities/responsive_wrapper.dart';

class AppDot extends StatelessWidget {
  AppDot({
    this.color = appGrey4,
    super.key,
  });

  Color color;

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    return Container(
      height: responsiveData.dotSize,
      width: responsiveData.dotSize,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(responsiveData.largeRadius),
      ),
    );
  }
}