import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AppTheme {
  ThemeData get light => ThemeData(
      appBarTheme: AppBarTheme(
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
          fontSize: 24.sp,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Polysans',
          color: Colors.black,
          fontSize: 16.sp,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Polysans',
          color: Colors.black,
          fontSize: 14.sp,
        ),
      ));
}