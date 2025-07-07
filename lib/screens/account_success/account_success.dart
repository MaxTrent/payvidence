import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/utilities/theme_mode.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/responsive.dart';
import '../../utilities/responsive_wrapper.dart';
import '../onboarding/onboarding.dart';

@RoutePage(name: 'AccountSuccessRoute')
class AccountSuccessScreen extends HookWidget {
  const AccountSuccessScreen({super.key});

  Future<dynamic> buildBottomSheet(
      BuildContext context, bool isDarkMode, String title, String body, VoidCallback? onContinue) {
    final responsiveData = ResponsiveInherited.of(context);

    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) {
        return Container(
          height: responsiveData.scaleHeight(800),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(responsiveData.radius),
              topLeft: Radius.circular(responsiveData.radius),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: responsiveData.paddingHorizontal,
                vertical: responsiveData.scaleHeight(10)),
            child: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.only(bottom: responsiveData.scaleHeight(70)),
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(140)),
                      child: Container(
                        height: responsiveData.scaleHeight(5),
                        width: responsiveData.scaleWidth(67),
                        decoration: BoxDecoration(
                          color: isDarkMode ? Colors.white54 : const Color(0xffd9d9d9),
                          borderRadius: BorderRadius.circular(responsiveData.radius),
                        ),
                      ),
                    ),
                    SizedBox(height: responsiveData.spacingVertical),
                    Row(
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
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            color: isDarkMode ? Colors.white : Colors.black,
                            Icons.close,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: responsiveData.scaleHeight(32)),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: responsiveData.scaleHeight(40),
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: responsiveData.scaleHeight(24)),
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
                    padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(14)),
                    child: SizedBox(
                      height: responsiveData.minButtonHeight,
                      child: AppButton(
                        height: responsiveData.minButtonHeight,
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
    final responsiveData = ResponsiveInherited.of(context);

    const privacyPolicyContent = '''
At Payvidence, we prioritize your privacy and the security of your personal information. This Privacy Policy outlines how we collect, use, and share the information you provide when using our mobile application and related services. By using Payvidence, you consent to the practices described in this policy.\n\n
1. Information We Collect\n
- Account Data: Business name, owner details\n
- Transaction Data: Sales records, payment info\n
- Technical Data: IP address, device type\n\n
2. Legal Basis for Processing\n
- Contractual necessity (service delivery)\n
- Legitimate business interests\n
- Legal compliance (e.g., FIRS tax reporting)\n\n
3. Data Sharing\n
We may disclose information to:\n
- Payment processors (Paystack/Flutterwave)\n
- Regulatory authorities (when legally required)\n\n
4. Data Security\n
- AES-256 encryption for all data\n
- Regular penetration testing\n
- NDPR-compliant storage (AWS Africa servers)\n\n
5. User Rights\n
You may:\n
- Request access to your data\n
- Correct inaccuracies\n
- Delete account (subject to tax retention requirements)\n\n
6. Cookies\n
We use essential cookies for:\n
- Session management\n
- Security purposes\n\n
7. Policy Updates\n
Users will be notified 30 days prior to material changes.
''';

    const termsAndConditionsContent = '''
These Terms and Conditions govern your use of PAYVIDENCE (the "Service"). By accessing or using the Service, you agree to be bound by these Terms. If you disagree, discontinue use immediately.\n\n
1. Acceptance of Terms\n
By accessing or using PAYVIDENCE, you agree to be bound by these Terms. If you disagree, discontinue use immediately.\n\n
2. Service Description\n
PAYVIDENCE provides:\n
- Digital sales and inventory management tools\n
- Payment processing integrations\n
- Financial reporting features\n\n
3. User Obligations\n
You must:\n
- Be at least 18 years old\n
- Provide accurate business information\n
- Not use the Service for illegal activities\n\n
4. Subscription Plans\n
- Starter: N20,000/year (500 transactions/month)\n
- Pro: N54,000/year (Unlimited transactions)\n
- Auto-renewal with 30-day cancellation notice\n\n
5. Payment Processing\n
- 0.75% fee applies to third-party payment integrations\n
- All transactions in Naira (₦)\n\n
6. Termination\n
We may suspend accounts for:\n
- Non-payment beyond 15 days\n
- Violation of these Terms\n\n
7. Limitation of Liability\n
PAYVIDENCE is not liable for:\n
- Indirect damages\n
- Losses from service interruptions\n\n
8. Governing Law\n
These Terms are governed by Nigerian law. Disputes shall be resolved in Abuja courts.
''';

    return ResponsiveWrapper(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding:  EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(20), vertical: responsiveData.scaleHeight(14)),
          child: AppButton(
            buttonText: 'Go to Home',
            onPressed: () {
              buildBottomSheet(
                context,
                isDarkMode,
                'Our Privacy\nPolicy',
                privacyPolicyContent,
                    () {
                  buildBottomSheet(
                    context,
                    isDarkMode,
                    'Terms and\nConditions',
                    termsAndConditionsContent,
                        () {
                      locator<PayvidenceAppRouter>()
                          .popUntil((route) => route is OnboardingScreen);
                      locator<PayvidenceAppRouter>()
                          .navigateNamed(PayvidenceRoutes.login);
                    },
                  );
                },
              );
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  Assets.svg.profileConfetti,
                  height: responsiveData.scaleHeight(200),
                  width: responsiveData.scaleWidth(200),
                ),
                SizedBox(height: responsiveData.scaleHeight(40)),
                Text(
                  'Account created!',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: responsiveData.scaleHeight(10)),
                Text(
                  'Your account has been successfully created. You can log in now to proceed to Home.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall!,
                ),
                SizedBox(height: responsiveData.scaleHeight(32)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}