import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/utilities/theme_mode.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../onboarding/onboarding.dart';

@RoutePage(name: 'AccountSuccessRoute')
class AccountSuccessScreen extends HookWidget {
  const AccountSuccessScreen({super.key});

  Future<dynamic> buildBottomSheet(
      BuildContext context, bool isDarkMode, String title, String body, VoidCallback? onContinue) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) {
        return Container(
          height: 800.h,
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
                  padding: EdgeInsets.only(bottom: 70.h), // Add bottom padding to account for the button
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
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            color: isDarkMode ? Colors.white : Colors.black,
                            Icons.close,
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
                    Text(
                      body,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
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
                        buttonText: 'Continue',
                        textColor: Colors.white,
                        backgroundColor: primaryColor2,
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (onContinue != null) {
                            onContinue();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;

    final privacyPolicyContent = '''
At Payvidence, we prioritize your privacy and the security of your personal information. This Privacy Policy outlines how we collect, use, and share the information you provide when using our mobile application and related services. By using Payvidence, you consent to the practices described in this policy.
We collect various types of information to enhance your experience with Payvidence. This includes personal details like your name, email address, and phone number, which you provide when creating an account. We also collect transaction data, including payment details and purchase history, to help you manage your transactions and invoices efficiently. Additionally, we gather usage data to understand how you interact with the app, including the features you use and the actions you take. We may also collect information about your device, such as IP address and browser type, and use cookies to track activity and improve your experience.
Your information is used to operate and improve the app, personalize your experience, and communicate with you about updates and relevant information. We also use your data to ensure the security of Payvidence and comply with legal obligations. While we do not share your personal information with third parties except in specific situations, such as working with service providers or complying with legal requirements, we are committed to protecting your privacy.
We implement reasonable security measures to safeguard your information, but please note that no method of transmission over the internet or electronic storage is completely secure. You have the option to update or delete your account information at any time, manage your cookie preferences, and opt-out of promotional communications.
Payvidence is not intended for children under 13, and we do not knowingly collect personal information from them. If we discover that we have inadvertently collected such information, we will delete it promptly. We may update this Privacy Policy as needed to reflect changes in our practices or legal requirements. By continuing to use Payvidence, you accept any changes to this policy
''';

    final termsAndConditionsContent = '''
By using our app, you confirm that you are of legal age in your jurisdiction or have the consent of a guardian. You are responsible for keeping your account details secure and for all activities under your account.
You agree to use Payvidence for lawful purposes only and in a way that does not harm, disable, or overburden the app or its users. Unauthorized access to any part of the app, other accounts, or our systems is prohibited. The app and its content, including text, graphics, logos, and software, are the exclusive property of Payvidence or its licensors. You may use the app for personal, non-commercial purposes, but you may not reproduce, distribute, or modify any content without our permission. Any transactions you conduct through Payvidence must be accurate and complete. We are not responsible for any losses resulting from incorrect transaction information provided by you. We reserve the right to suspend or terminate your access to the app at any time if we believe you have violated these terms or engaged in harmful behavior.
''';

    return Scaffold(
      floatingActionButton: AppButton(
        buttonText: 'Go to Home',
        onPressed: () {
          // Show Privacy Policy bottom sheet
          buildBottomSheet(
            context,
            isDarkMode,
            'Our Privacy\nPolicy',
            privacyPolicyContent,
                () {
              // Show Terms and Conditions bottom sheet
              buildBottomSheet(
                context,
                isDarkMode,
                'Terms and\nConditions',
                termsAndConditionsContent,
                    () {
                  // Navigate to Login
                  locator<PayvidenceAppRouter>()
                      .popUntil((route) => route is OnboardingScreen);
                  locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.login);
                },
              );
            },
          );
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.svg.profileConfetti),
              SizedBox(height: 40.h),
              Text(
                'Account created!',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 10.h),
              Text(
                'Your account has been successfully created. You can log in now to proceed to Home.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall!,
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}