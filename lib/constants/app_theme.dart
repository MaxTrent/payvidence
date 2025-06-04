import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../gen/assets.gen.dart';
import '../utilities/responsive.dart';

class AppTheme {
  ThemeData lightTheme(BuildContext context) => ThemeData(
    brightness: Brightness.light,
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (BuildContext context) =>
          SvgPicture.asset(Assets.svg.backbutton),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      elevation: 0.0,
    ),
    splashColor: Colors.transparent,
    useMaterial3: false,
    highlightColor: Colors.transparent,
    applyElevationOverlayColor: true,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.black,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, brightness: Brightness.light),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Polysans',
        color: Colors.black,
        fontSize: Responsive.fontSize(context, 24),
        fontWeight: FontWeight.w600,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Polysans',
        color: Colors.black,
        fontSize: Responsive.fontSize(context, 18),
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Polysans',
        color: Colors.black,
        fontSize: Responsive.fontSize(context, 16),
        fontWeight: FontWeight.w400,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black.withOpacity(0.5),
      selectedLabelStyle: TextStyle(
        fontFamily: 'Polysans',
        fontSize: Responsive.fontSize(context, 12),
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Polysans',
        fontSize: Responsive.fontSize(context, 12),
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Responsive.radius(context))), // Replaces 20.r
      ),
    ),
  );

  ThemeData darkTheme(BuildContext context) => ThemeData(
    brightness: Brightness.dark,
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (BuildContext context) => SvgPicture.asset(
        Assets.svg.backbutton,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      scrolledUnderElevation: 0,
      elevation: 0.0,
    ),
    splashColor: Colors.transparent,
    useMaterial3: false,
    highlightColor: Colors.transparent,
    applyElevationOverlayColor: true,
    scaffoldBackgroundColor: const Color(0xff121212),
    primaryColor: Colors.black,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.black, brightness: Brightness.dark),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Polysans',
        color: Colors.white,
        fontSize: Responsive.fontSize(context, 28),
        fontWeight: FontWeight.w600,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Polysans',
        color: Colors.white,
        fontSize: Responsive.fontSize(context, 18),
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Polysans',
        color: Colors.white,
        fontSize: Responsive.fontSize(context, 16),
        fontWeight: FontWeight.w400,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xff121212),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white.withOpacity(0.5),
      selectedLabelStyle: TextStyle(
        fontFamily: 'Polysans',
        fontSize: Responsive.fontSize(context, 12),
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      unselectedLabelStyle: TextStyle(
        fontFamily: 'Polysans',
        fontSize: Responsive.fontSize(context, 12),
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: const Color(0xff1E1E1E),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Responsive.radius(context))), // Replaces 20.r
      ),
    ),
  );
}