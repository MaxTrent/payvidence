import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payvidence/components/app_button.dart';

import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';

class AccountSuccessScreen extends StatelessWidget {
  const AccountSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AppButton(
          buttonText: 'Go to Home',
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                clipBehavior: Clip.none,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Stack(
                      children: [
                        ListView(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 48.h,
                                ),
                                Text(
                                  'PAYVIDENCE',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w700,
                                          color: primaryColor2),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 32.h,
                            ),
                            Text(
                              'Our Privacy\nPolicy',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(fontSize: 40.h),
                            ),
                            SizedBox(
                              height: 24.h,
                            ),
                            Text(
                              'At Payvidence, we prioritize your privacy and the security of your personal information. This Privacy Policy outlines how we collect, use, and share the information you provide when using our mobile application and related services. By using Payvidence, you consent to the practices described in this policy.\nWe collect various types of information to enhance your experience with Payvidence. This includes personal details like your name, email address, and phone number, which you provide when creating an account. We also collect transaction data, including payment details and purchase history, to help you manage your transactions and invoices efficiently. Additionally, we gather usage data to understand how you interact with the app, including the features you use and the actions you take. We may also collect information about your device, such as IP address and browser type, and use cookies to track activity and improve your experience.\nYour information is used to operate and improve the app, personalize your experience, and communicate with you about updates and relevant information. We also use your data to ensure the security of Payvidence and comply with legal obligations. While we do not share your personal information with third parties except in specific situations, such as working with service providers or complying with legal requirements, we are committed to protecting your privacy.\nWe implement reasonable security measures to safeguard your information, but please note that no method of transmission over the internet or electronic storage is completely secure. You have the option to update or delete your account information at any time, manage your cookie preferences, and opt-out of promotional communications.\nPayvidence is not intended for children under 13, and we do not knowingly collect personal information from them. If we discover that we have inadvertently collected such information, we will delete it promptly. We may update this Privacy Policy as needed to reflect changes in our practices or legal requirements. By continuing to use Payvidence, you accept any changes to this policy',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            child: Container(
                                height: 124.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: SizedBox(
                                    height: 56.h,
                                    child: AppButton(height: 56.h, buttonText: 'Continue', onPressed: (){}))),
                          ),
                        )
                      ],
                    ),
                  );
                });
          }),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.svg.profileConfetti),
              SizedBox(
                height: 40.h,
              ),
              Text(
                'Account created!',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Your account has been successfully created. You can log in now to proceed to Home.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall!,
              ),
              SizedBox(
                height: 32.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
