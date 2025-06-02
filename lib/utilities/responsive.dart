import 'dart:math';

import 'package:flutter/material.dart';

class Responsive {
  static double getWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double getHeight(BuildContext context) => MediaQuery.of(context).size.height;

  // Padding and spacing
  static double paddingHorizontal(BuildContext context) => getWidth(context) * 0.055; // Approx 20.w
  static double spacingVertical(BuildContext context) => getHeight(context) * 0.045; // Approx 32.h

  // Font scaling
  static double fontSize(BuildContext context, double baseSize) => baseSize * (getWidth(context) / 390);

  // Radii
  static double radius(BuildContext context) => min(getWidth(context), getHeight(context)) * 0.111; // Approx 40.r
  static double largeRadius(BuildContext context) => min(getWidth(context), getHeight(context)) * 0.067; // Approx 24.r
  static double smallRadius(BuildContext context) => min(getWidth(context), getHeight(context)) * 0.033; // Approx 12.r

  // Specific sizes
  static double dotSize(BuildContext context) => getHeight(context) * 0.007; // Approx 6.h
  static double minButtonWidth(BuildContext context) => getWidth(context) * 0.897; // Approx 350.w
  static double minButtonHeight(BuildContext context) => getHeight(context) * 0.071; // Approx 60.h

  // Generic scaling methods
  static double scaleHeight(BuildContext context, double value) => getHeight(context) * (value / 844);
  static double scaleWidth(BuildContext context, double value) => getWidth(context) * (value / 390);
}