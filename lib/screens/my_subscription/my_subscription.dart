import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/constants/app_colors.dart';

import '../../gen/assets.gen.dart';

class MySubscription extends StatelessWidget {
  const MySubscription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My subscription', style: Theme.of(context).textTheme.displayLarge,),
          SizedBox(height: 24.h,),
            Container(
            height: 108.h,
            decoration: BoxDecoration(
              color: const Color(0xffE3DDFF),
              borderRadius: BorderRadius.circular(12.r)
            ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(Assets.svg.ribbon),
                          SizedBox(width: 8.w,),
                          const Text('Premium subscription plan'),
                        ],
                      ),

                      Container(height: 34.h,
                      width: 84.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40.r),
                      ),
                        child: Center(child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.check, size: 12.h,),
                              Text('Active', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp),),
                            ],
                          ),
                        )),
                      )
                    ],
                  ),
                  // SizedBox(height: 4.h,),
                    Text.rich(TextSpan(
                      text: '₦50,000 ',
                      style: Theme.of(context).textTheme.displayLarge,
                      children: [
                        TextSpan(
                          text: '/year',
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(color: const Color(0xff444444)),

                        )
                      ]
                    )),
                    // Text('₦50,000 /year', style: Theme.of(context).textTheme.displayLarge,),


                  ],
                ),
              ),

          ),
            SizedBox(height: 32.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Current plan', style: Theme.of(context).textTheme.displaySmall,),
                Row(
                  children: [
                    Container(
                      height: 12.h,
                      width: 12.h,
                      decoration: const BoxDecoration(
                        color: primaryColor2,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w,),
                    Text('Premium', style: Theme.of(context).textTheme.displaySmall,),
                  ],
                ),

              ],
            ),
            SizedBox(height: 18.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subscription date', style: Theme.of(context).textTheme.displaySmall,),
                Text('September 2, 2024', style: Theme.of(context).textTheme.displaySmall,),

              ],
            ),
            SizedBox(height: 18.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Expiration date', style: Theme.of(context).textTheme.displaySmall,),
                Text('September 2, 2025', style: Theme.of(context).textTheme.displaySmall,),
              ],
            ),
            SizedBox(height: 40.h,),
            Text('Subscription history', style: Theme.of(context).textTheme.displayMedium,),
            SizedBox(height: 12.h,),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                height: 56.h,
                width: 56.w,
                decoration: const BoxDecoration(
                  color: primaryColor4,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding:  EdgeInsets.all(14.h),
                  child: SvgPicture.asset(Assets.svg.ribbon),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Premium Plan', style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 16.sp),),
                  SizedBox(height: 8.h,),
                  Text('₦50,000.00', style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 16.sp),),
                ],
              ),
              trailing: Text('Sept. 2, 2024', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, color: const Color(0xff979797)),),
            ),
            SizedBox(height: 36.h,),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                height: 56.h,
                width: 56.w,
                decoration: const BoxDecoration(
                  color: primaryColor4,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding:  EdgeInsets.all(14.h),
                  child: SvgPicture.asset(Assets.svg.ribbon),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Business Plan', style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 16.sp),),
                  SizedBox(height: 8.h,),
                  Text('₦10,000.00', style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 16.sp),),
                ],
              ),
              trailing: Text('Sept. 2, 2023', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, color: const Color(0xff979797)),),
            ),
            SizedBox(height: 60.h,),
            AppButton(buttonText: 'Manage subscription', onPressed: (){}),
            SizedBox(height: 26.h,),
            Center(child: Text('Cancel subscription', style: Theme.of(context).textTheme.displayMedium!.copyWith(color: appRed),))
          ],
        ),
      ),
    );
  }
}
