import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shimmer/shimmer.dart';
import '../utilities/theme_mode.dart';
import '../utilities/animations.dart';

class CustomShimmer extends HookWidget {
  final double? height;
  final double? width;

  const CustomShimmer({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;

    return FadeInWidget(
      duration: AppAnimations.fast,
      child: Shimmer.fromColors(
        baseColor: isDarkMode ? const Color(0xFF444444) : const Color(0xFFEBEBF4),
        highlightColor: isDarkMode ? const Color(0xFF555555) : const Color(0xFFF4F4F4),
        child: Container(
          height: height ?? 40,
          width: width,
          color: isDarkMode ? const Color(0xFF444444) : const Color(0xFFEBEBF4),
        ),
      ),
    );
  }
}