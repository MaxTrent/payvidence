import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import '../../components/app_button.dart';
import '../../gen/assets.gen.dart';

@RoutePage(name: 'SubscriptionPrompt')
class SubscriptionPrompt extends StatelessWidget {
  const SubscriptionPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: responsiveData.scaleHeight(116),
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     SvgPicture.asset(Assets.svg.productSuccess),
              //      SizedBox(height: responsiveData.scaleHeight(40)),
              //      Text('Restricted feature!', style: Theme.of(context).textTheme.displayLarge,),
              //      SizedBox(height: responsiveData.scaleHeight(10)),
              //      Text('Your current plan does not allow this feature. You will need to upgrade your plan to continue.',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: Responsive.fontSize(context, 14), ))
              //   ],
              // ),

              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     SvgPicture.asset(Assets.svg.subfailed),
              //     SizedBox(height: responsiveData.scaleHeight(40)),
              //     Text('Subscription failed!', style: Theme.of(context).textTheme.displayLarge,),
              //     SizedBox(height: responsiveData.scaleHeight(10)),
              //     Text('Hi Peter, set-up a business on Payvidence so you can enjoy our services.',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: Responsive.fontSize(context, 14), ))
              //   ],
              // ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(Assets.svg.subsuccess),
                  SizedBox(
                    height: responsiveData.scaleHeight(40),
                  ),
                  Text(
                    'Subscription successful!!',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(10),
                  ),
                  Text(
                    'You have successfully paid for Premium subscription plan. You can now explore our premium benefits and features.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      fontSize: Responsive.fontSize(context, 14),
                    ),
                  )
                ],
              ),

              SizedBox(
                height: responsiveData.scaleHeight(176),
              ),
              Column(
                children: [
                  // AppButton(buttonText: 'Upgrade plan', onPressed: (){}),

                  // AppButton(buttonText: 'Try again', onPressed: (){}),

                  AppButton(buttonText: 'Alright!', onPressed: () {}),

                  // SizedBox(height: responsiveData.scaleHeight(26)),
                  // GestureDetector(
                  //   onTap: (){},
                  //   child: Text(
                  //     'Go back',
                  //     style: Theme.of(context)
                  //         .textTheme
                  //         .displayMedium!
                  //         .copyWith(color: primaryColor2),
                  //   ),
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}