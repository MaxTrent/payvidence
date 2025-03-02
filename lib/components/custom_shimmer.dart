import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double? height;
  const CustomShimmer({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFEBEBF4),
      highlightColor: const Color(0xFFF4F4F4),
      child: Container(
        height: height ?? 40,
        color: const Color(0xFFEBEBF4),
      ),
    );
  }
}