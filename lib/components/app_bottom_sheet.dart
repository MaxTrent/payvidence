import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';

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
    return Container(
      height: height.h,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.r),
          topLeft: Radius.circular(40.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(bottom: 70.h), // Prevent overlap with button
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 140.w),
                  child: Container(
                    height: 5.h,
                    width: 67.w,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white54 : const Color(0xffd9d9d9),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                ),
                SizedBox(height: 38.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PAYVIDENCE',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: primaryColor2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => locator<PayvidenceAppRouter>().back(),
                      child: Icon(
                        Icons.close,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                Text(
                  title,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: 40.h,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 24.h),
                ...children,
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                child: SizedBox(
                  height: 56.h,
                  child: AppButton(
                    height: 56.h,
                    buttonText: buttonText,
                    textColor: Colors.white,
                    backgroundColor: primaryColor2,
                    onPressed: onButtonPressed ?? () => locator<PayvidenceAppRouter>().back(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}