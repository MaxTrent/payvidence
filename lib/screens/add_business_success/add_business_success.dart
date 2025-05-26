import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../components/app_button.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/responsive.dart';
import '../../utilities/responsive_wrapper.dart';

@RoutePage(name: 'AddBusinessSuccessRoute')
class AddBusinessSuccess extends StatelessWidget {
  const AddBusinessSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.svg.briefcaseConfetti,
                height: responsiveData.scaleHeight(200),
                width: responsiveData.scaleWidth(200),
              ),
              SizedBox(
                height: responsiveData.scaleHeight(40),
              ),
              Text(
                'Business added!',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: responsiveData.scaleHeight(10),
              ),
              Text(
                'Keekee Store has been successfully added to your account. You can start performing transactions for the business.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontSize: Responsive.fontSize(context, 14),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: AppButton(
          buttonText: 'Alright!',
          onPressed: () {
            locator<PayvidenceAppRouter>()
                .navigateNamed(PayvidenceRoutes.allBusiness);
          },
        ),
      ),
    );
  }
}