import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import '../../gen/assets.gen.dart';

@RoutePage(name: 'EmptyBusinessRoute')
class EmptyBusiness extends StatelessWidget {
  const EmptyBusiness({super.key});

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.svg.emptyBriefcase),
              SizedBox(
                height: responsiveData.scaleHeight(40),
              ),
              Text(
                'No business added!',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: responsiveData.scaleHeight(10),
              ),
              Text(
                'Start generating receipts and invoices for your business. All transactions will show here.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontSize: Responsive.fontSize(context, 14),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: AppButton(
          buttonText: 'Set-up business',
          onPressed: () {
            locator<PayvidenceAppRouter>()
                .navigateNamed(PayvidenceRoutes.addBusiness);
          },
        ),
      ),
    );
  }
}