import 'package:flutter/material.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/responsive.dart';
import '../utilities/responsive_wrapper.dart';
import '../utilities/animations.dart';

class AppBottomSheet extends StatelessWidget {
  final bool isDarkMode;
  final String title;
  final List<Widget> children;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final double height;

  const AppBottomSheet({
    super.key,
    required this.isDarkMode,
    required this.title,
    required this.children,
    this.buttonText = 'Continue',
    this.onButtonPressed,
    this.height = 800,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);
    final sheetHeight = responsiveData.scaleHeight(height);
    final paddingHorizontal = responsiveData.paddingHorizontal;
    final paddingVertical = responsiveData.scaleHeight(10);
    final dragHandleHeight = responsiveData.scaleHeight(5);
    final dragHandleWidth = responsiveData.scaleWidth(67);
    final dragHandlePadding = responsiveData.scaleWidth(140);
    final spacingLarge = responsiveData.scaleHeight(38);
    final spacingMedium = responsiveData.spacingVertical;
    final spacingSmall = responsiveData.scaleHeight(24);
    final listViewPaddingBottom = responsiveData.scaleHeight(70);
    final buttonPaddingVertical = responsiveData.scaleHeight(14);
    final buttonHeight = responsiveData.scaleHeight(56);

    return SlideInWidget(
      begin: const Offset(0, 1),
      duration: AppAnimations.slow,
      child: Container(
        height: sheetHeight,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(responsiveData.radius),
            topLeft: Radius.circular(responsiveData.radius),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: paddingVertical),
          child: Stack(
            children: [
              ListView(
                padding: EdgeInsets.only(bottom: listViewPaddingBottom),
                children: [
                  FadeInWidget(
                    delay: const Duration(milliseconds: 200),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: dragHandlePadding),
                      child: Container(
                        height: dragHandleHeight,
                        width: dragHandleWidth,
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.white54 : const Color(0xffd9d9d9),
                          borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: spacingLarge),
                  SlideInWidget(
                    begin: const Offset(-0.3, 0),
                    delay: const Duration(milliseconds: 300),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PAYVIDENCE',
                          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontSize: Responsive.fontSize(context, 24),
                            fontWeight: FontWeight.w700,
                            color: primaryColor2,
                          ),
                        ),
                        AnimatedPressButton(
                          onPressed: () => locator<PayvidenceAppRouter>().back(),
                          child: Icon(
                            Icons.close,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: spacingMedium),
                  FadeInWidget(
                    delay: const Duration(milliseconds: 400),
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: Responsive.fontSize(context, 40),
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: spacingSmall),
                  ...children.asMap().entries.map((entry) {
                    return SlideInWidget(
                      delay: Duration(milliseconds: 500 + (entry.key * 100)),
                      begin: const Offset(0, 0.2),
                      child: entry.value,
                    );
                  }).toList(),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SlideInWidget(
                  begin: const Offset(0, 1),
                  delay: const Duration(milliseconds: 600),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: buttonPaddingVertical),
                    child: SizedBox(
                      height: buttonHeight,
                      child: AppButton(
                        height: buttonHeight,
                        buttonText: buttonText,
                        textColor: Colors.white,
                        backgroundColor: primaryColor2,
                        onPressed: onButtonPressed ?? () => locator<PayvidenceAppRouter>().back(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}