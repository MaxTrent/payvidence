import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payvidence/constants/app_colors.dart';
import '../../components/app_button.dart';
import '../../gen/assets.gen.dart';

@RoutePage(name: 'SubscriptionPrompt')
class SubscriptionPrompt extends StatelessWidget {
  const SubscriptionPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 116.h,),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     SvgPicture.asset(Assets.svg.productSuccess),
            //      SizedBox(height: 40.h,),
            //      Text('Restricted feature!', style: Theme.of(context).textTheme.displayLarge,),
            //      SizedBox(height: 10.h,),
            //      Text('Your current plan does not allow this feature. You will need to upgrade your plan to continue.',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, ))
            //   ],
            // ),

            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     SvgPicture.asset(Assets.svg.subfailed),
            //     SizedBox(height: 40.h,),
            //     Text('Subscription failed!', style: Theme.of(context).textTheme.displayLarge,),
            //     SizedBox(height: 10.h,),
            //     Text('Hi Peter, set-up a business on Payvidence so you can enjoy our services.',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, ))
            //   ],
            // ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(Assets.svg.subsuccess),
                SizedBox(height: 40.h,),
                Text('Subscription successful!!', style: Theme.of(context).textTheme.displayLarge,),
                SizedBox(height: 10.h,),
                Text('You have successfully paid for Premium subscription plan. You can now explore our premium benefits and features.',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, ))
              ],
            ),

            SizedBox(height: 176.h,),
            Column(
              children: [
                // AppButton(buttonText: 'Upgrade plan', onPressed: (){
                // }),

                // AppButton(buttonText: 'Try again', onPressed: (){
                // }),

                AppButton(buttonText: 'Alright!', onPressed: (){
                }),

                // SizedBox(height: 26.h),
                // GestureDetector(
                //   onTap: (){
                //   },
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

    );
  }
}
