import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import '../../components/app_button.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';

@RoutePage(name: 'UpgradeSubscriptionRoute')
class UpgradeSubscription extends StatelessWidget {
  const UpgradeSubscription({super.key});

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.svg.exclamation),
                  SizedBox(
                    height: responsiveData.scaleHeight(40),
                  ),
                  Text(
                    'Upgrade subscription!',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(10),
                  ),
                  Text(
                    'You are currently on the Starter plan! Upgrade to enjoy more benefits and explore more features on Payvidence,',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: Responsive.fontSize(context, 14),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: responsiveData.scaleHeight(34),
                child: Column(
                  children: [
                    AppButton(
                      buttonText: 'Upgrade plan',
                      onPressed: () {
                        // context.go(AppRoutes.allBusiness);
                      },
                    ),
                    SizedBox(height: responsiveData.scaleHeight(26)),
                    GestureDetector(
                      onTap: () {
                        // context.go('/login');
                      },
                      child: Text(
                        'Continue with Starter plan',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: primaryColor2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}