import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../components/app_button.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/responsive_wrapper.dart';
import '../onboarding/onboarding.dart';

@RoutePage(name: 'ChangePasswordSuccessRoute')
class ChangePasswordSuccess extends StatelessWidget {
  const ChangePasswordSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: Scaffold(
        floatingActionButton: AppButton(
          buttonText: 'Log in',
          onPressed: () {
            locator<PayvidenceAppRouter>()
                .popUntil((route) => route is OnboardingScreen);
            locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.login);
          },
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
                  'Password changed!',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(10),
                ),
                Text(
                  'Your password has been successfully changed. You can log in now to proceed to Home.',
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