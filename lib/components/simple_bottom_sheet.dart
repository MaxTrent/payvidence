import 'package:flutter/material.dart';
import 'package:payvidence/utilities/responsive.dart';
import '../utilities/responsive_wrapper.dart';

class SimpleBottomSheet extends StatelessWidget {
  final bool isDarkMode;
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final double height;

  const SimpleBottomSheet({
    super.key,
    required this.isDarkMode,
    required this.title,
    this.subtitle,
    required this.children,
    this.height = 326,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    return Container(
      height: responsiveData.scaleHeight(height),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(responsiveData.largeRadius),
          topLeft: Radius.circular(responsiveData.largeRadius),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: responsiveData.paddingHorizontal,
            vertical: responsiveData.scaleHeight(10)),
        child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(140)),
                  child: Container(
                    height: responsiveData.scaleHeight(5),
                    width: responsiveData.scaleWidth(67),
                    decoration: BoxDecoration(
                      color: const Color(0xffd9d9d9),
                      borderRadius: BorderRadius.circular(responsiveData.largeRadius),
                    ),
                  ),
                ),
                SizedBox(height: responsiveData.scaleHeight(38)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox.shrink(),
                    Center(
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                          fontSize: Responsive.fontSize(context, 22),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.close,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                if (subtitle != null) ...[
                  SizedBox(height: responsiveData.scaleHeight(12)),
                  Center(
                    child: Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                ],
                SizedBox(height: responsiveData.scaleHeight(40)),
                ...children,
              ],
            ),
          ],
        ),
      ),
    );
  }
}