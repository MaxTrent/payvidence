import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payvidence/utilities/responsive.dart';
import '../gen/assets.gen.dart';
import '../utilities/responsive_wrapper.dart';
import '../utilities/theme_mode.dart';

class CategoryTile extends HookWidget {
  const CategoryTile({
    required this.title,
    required this.subtitle,
    super.key,
    required this.onPressed,
  });

  final String title;
  final String subtitle;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final responsiveData = ResponsiveInherited.of(context);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: responsiveData.scaleHeight(70), // Replaces 70.h
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xffF0F0F0),
              width: responsiveData.scaleHeight(1), // Replaces 1.h
            ),
          ),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              Assets.svg.shapes,
              colorFilter: ColorFilter.mode(isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn),
              height: responsiveData.scaleHeight(24), // Example size
              width: responsiveData.scaleWidth(24),
            ),
            SizedBox(
              width: responsiveData.scaleWidth(16), // Replaces 16.w
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: Responsive.fontSize(context, 14), // Replaces 14.sp
                    ),
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(4), // Replaces 4.h
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: Responsive.fontSize(context, 14), // Replaces 14.sp
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}