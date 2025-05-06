import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/gen/assets.gen.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/theme_mode.dart';
import 'package:payvidence/utilities/toast_service.dart';
import 'package:url_launcher/url_launcher.dart';
import '../profile/profile.dart';

@RoutePage(name: 'PayvidenceInfoRoute')
class PayvidenceInfo extends HookWidget {
  const PayvidenceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'Payvidence information',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 32.h,
            ),
            Divider(
              thickness: 1.h,
            ),
            ProfileOptionTile(
              isDarkMode: isDarkMode,
              icon: Assets.svg.privacy,
              title: 'Privacy policy',
              onTap: () {
                buildBottomSheet(
                  context,
                  isDarkMode,
                  'Our Privacy\nPolicy',
                  'At Payvidence, we prioritize your privacy and the security of your personal information. This Privacy Policy outlines how we collect, use, and share the information you provide when using our mobile application and related services. By using Payvidence, you consent to the practices described in this policy.\n\n'
                      '1. Information We Collect\n'
                      '- Account Data: Business name, owner details\n'
                      '- Transaction Data: Sales records, payment info\n'
                      '- Technical Data: IP address, device type\n\n'
                      '2. Legal Basis for Processing\n'
                      '- Contractual necessity (service delivery)\n'
                      '- Legitimate business interests\n'
                      '- Legal compliance (e.g., FIRS tax reporting)\n\n'
                      '3. Data Sharing\n'
                      'We may disclose information to:\n'
                      '- Payment processors (Paystack/Flutterwave)\n'
                      '- Regulatory authorities (when legally required)\n\n'
                      '4. Data Security\n'
                      '- AES-256 encryption for all data\n'
                      '- Regular penetration testing\n'
                      '- NDPR-compliant storage (AWS Africa servers)\n\n'
                      '5. User Rights\n'
                      'You may:\n'
                      '- Request access to your data\n'
                      '- Correct inaccuracies\n'
                      '- Delete account (subject to tax retention requirements)\n\n'
                      '6. Cookies\n'
                      'We use essential cookies for:\n'
                      '- Session management\n'
                      '- Security purposes\n\n'
                      '7. Policy Updates\n'
                      'Users will be notified 30 days prior to material changes.',
                );
              },
            ),
            SizedBox(
              height: 28.h,
            ),
            ProfileOptionTile(
              isDarkMode: isDarkMode,
              icon: Assets.svg.terms,
              title: 'Terms and conditions',
              onTap: () {
                buildBottomSheet(
                  context,
                  isDarkMode,
                  'Terms and\nConditions',
                  'These Terms and Conditions govern your use of PAYVIDENCE (the "Service"). By accessing or using the Service, you agree to be bound by these Terms. If you disagree, discontinue use immediately.\n\n'
                      '1. Acceptance of Terms\n'
                      'By accessing or using PAYVIDENCE, you agree to be bound by these Terms. If you disagree, discontinue use immediately.\n\n'
                      '2. Service Description\n'
                      'PAYVIDENCE provides:\n'
                      '- Digital sales and inventory management tools\n'
                      '- Payment processing integrations\n'
                      '- Financial reporting features\n\n'
                      '3. User Obligations\n'
                      'You must:\n'
                      '- Be at least 18 years old\n'
                      '- Provide accurate business information\n'
                      '- Not use the Service for illegal activities\n\n'
                      '4. Subscription Plans\n'
                      '- Starter: N20,000/year (500 transactions/month)\n'
                      '- Pro: N54,000/year (Unlimited transactions)\n'
                      '- Auto-renewal with 30-day cancellation notice\n\n'
                      '5. Payment Processing\n'
                      '- 0.75% fee applies to third-party payment integrations\n'
                      '- All transactions in Naira (₦)\n\n'
                      '6. Termination\n'
                      'We may suspend accounts for:\n'
                      '- Non-payment beyond 15 days\n'
                      '- Violation of these Terms\n\n'
                      '7. Limitation of Liability\n'
                      'PAYVIDENCE is not liable for:\n'
                      '- Indirect damages\n'
                      '- Losses from service interruptions\n\n'
                      '8. Governing Law\n'
                      'These Terms are governed by Nigerian law. Disputes shall be resolved in Abuja courts.',
                 );
              },
            ),
            SizedBox(
              height: 28.h,
            ),
            ProfileOptionTile(
              isDarkMode: isDarkMode,
              icon: Assets.svg.contactUs,
              title: 'Contact us',
              onTap: () {
                buildContactInfoBottomSheet(context, isDarkMode);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> buildContactInfoBottomSheet(BuildContext context, bool isDarkMode) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) {
        return Container(
          height: 398.h,
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
                    SizedBox(
                      height: 38.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Center(
                          child: Text(
                            'Contact us',
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.close,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Center(
                      child: Text(
                        'You can reach us via the modes below.',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        final uri = Uri.parse('mailto:info@payvidence.com');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        } else {
                          ToastService.showErrorSnackBar('No email app found');
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  Assets.svg.sms,
                                  colorFilter: ColorFilter.mode(
                                    isDarkMode ? Colors.white : Colors.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(
                                  width: 16.w,
                                ),
                                Text(
                                  'info@payvidence.com',
                                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                    fontSize: 14.sp,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SvgPicture.asset(
                              Assets.svg.arrowRight,
                              colorFilter: ColorFilter.mode(
                                isDarkMode ? Colors.white : Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 1.h,
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        final uri = Uri.parse('tel:+2347012123176');
                        try {
                          await launchUrl(uri);
                        } catch (e) {
                          ToastService.showErrorSnackBar('Unable to open dialer');
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  Assets.svg.call,
                                  colorFilter: ColorFilter.mode(
                                    isDarkMode ? Colors.white : Colors.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(
                                  width: 16.w,
                                ),
                                Text(
                                  '0701 212 3176',
                                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                    fontSize: 14.sp,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SvgPicture.asset(
                              Assets.svg.arrowRight,
                              colorFilter: ColorFilter.mode(
                                isDarkMode ? Colors.white : Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 1.h,
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                    GestureDetector(
                      onTap: () async {
                        Navigator.of(context).pop();
                        final message = Uri.encodeComponent('Hello, I want to know more about Payvidence');
                        final uri = Uri.parse('https://wa.me/+2347012123176?text=$message');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          ToastService.showErrorSnackBar('WhatsApp not installed');
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  Assets.svg.whatsapp,
                                  colorFilter: ColorFilter.mode(
                                    isDarkMode ? Colors.white : Colors.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(
                                  width: 16.w,
                                ),
                                Text(
                                  '0701 212 3176',
                                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                    fontSize: 14.sp,
                                    color: isDarkMode ? Colors.white : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SvgPicture.asset(
                              Assets.svg.arrowRight,
                              colorFilter: ColorFilter.mode(
                                isDarkMode ? Colors.white : Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      height: 1.h,
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> buildBottomSheet(
      BuildContext context, bool isDarkMode, String title, String body) {
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
                  padding: EdgeInsets.only(bottom: 75.h), // Add bottom padding to account for the button
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
                    SizedBox(
                      height: 38.h,
                    ),
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
                            Icons.close,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: 40.h,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
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
                        onPressed: () => locator<PayvidenceAppRouter>().back(),
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
}