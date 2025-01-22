import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../gen/assets.gen.dart';


class AppTheme {
  ThemeData get light => ThemeData(
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (BuildContext context) => SvgPicture.asset(Assets.svg.backbutton)
    ),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          elevation: 0.0
      ),
      splashColor: Colors.transparent,
      useMaterial3: false,
      highlightColor: Colors.transparent,
      applyElevationOverlayColor: true,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.black,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Polysans',
          color: Colors.black,
          fontSize: 28.sp,
          fontWeight: FontWeight.w600,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Polysans',
          color: Colors.black,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Polysans',
          color: Colors.black,
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
        ),
      ));
}