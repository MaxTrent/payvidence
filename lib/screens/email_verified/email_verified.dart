import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import 'package:payvidence/utilities/theme_mode.dart';
import '../../gen/assets.gen.dart';
import '../onboarding/onboarding.dart';

@RoutePage(name: 'EmailVerifiedRoute')
class EmailVerifiedScreen extends HookWidget {
  const EmailVerifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = useThemeMode();
    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: Scaffold(
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
                  'Email Verified!',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: responsiveData.scaleHeight(10)),
                Text(
                  'Your email has been successfully verified. You can now log in to your account.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall!,
                ),
                SizedBox(height: responsiveData.scaleHeight(32)),
                AppButton(
                  buttonText: 'Continue to Login',
                  onPressed: () {
                    locator<PayvidenceAppRouter>().popUntil(
                        (route) => route is OnboardingScreen);
                    locator<PayvidenceAppRouter>()
                        .navigateNamed(PayvidenceRoutes.login);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}