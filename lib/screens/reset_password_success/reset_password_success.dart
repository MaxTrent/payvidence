import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import 'package:flutter_svg/svg.dart';
import '../../components/app_button.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../onboarding/onboarding.dart';

@RoutePage(name: 'ResetPasswordSuccessRoute')
class ResetPasswordSuccess extends StatelessWidget {
  const ResetPasswordSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: KeyboardDismissibleScaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding:  EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(20), vertical: responsiveData.scaleHeight(14)),
          child: AppButton(
              buttonText: 'Log in',
              onPressed: () {
                locator<PayvidenceAppRouter>()
                    .popUntil((route) => route is OnboardingScreen);
                locator<PayvidenceAppRouter>()
                    .navigateNamed(PayvidenceRoutes.login);
              }),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(Assets.svg.passwordSuccess),
                SizedBox(
                  height: responsiveData.scaleHeight(40),
                ),
                Text(
                  'Password reset!',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(10),
                ),
                Text(
                  'Your password has been successfully reset. You can log in with your new password.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall!,
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(32),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}