import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/app_button.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';

class UpgradeSubscription extends StatelessWidget {
  const UpgradeSubscription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(Assets.svg.exclamation),
                SizedBox(height: 40.h,),
                Text('Upgrade subscription!', style: Theme.of(context).textTheme.displayLarge,),
                SizedBox(height: 10.h,),
                Text('You are currently on the Starter plan! Upgrade to enjoy more benefits and explore more features on Payvidence,',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, ))
              ],
            ),
            Positioned(
              bottom:
              34.h,
              child: Column(
                children: [
                  AppButton(buttonText: 'Upgrade plan', onPressed: (){
                    // context.go(AppRoutes.allBusiness);
                  }),
                  SizedBox(height: 26.h),
                  GestureDetector(
                    onTap: (){
                      // context.go('/login');
                    },
                    child: Text(
                      'Continue with Starter plan',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: primaryColor2),
                    ),
                  )

                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}
