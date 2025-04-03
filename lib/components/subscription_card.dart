import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../gen/assets.gen.dart';
import 'app_naira.dart';

class SubscriptionCard extends StatelessWidget {
  SubscriptionCard({
    required this.subscriptionTier,
    required this.price,
    this.active = false,
    this.recommended = false,
    this.checkOut = true,
    super.key,
  });

  String subscriptionTier;
  String price;
  bool active;
  bool recommended;
  bool checkOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 108.h,
      decoration: BoxDecoration(
          color: const Color(0xffE3DDFF),
          borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            recommended
                ? Container(
                    height: 26.h,
                    width: 108.w,
                    decoration: BoxDecoration(
                        color: const Color(0xff7767BD),
                        borderRadius: BorderRadius.circular(6.r)),
                    child: Center(
                      child: Text(
                        'RECOMMENDED',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 12.sp, color: Colors.white),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            recommended
                ? SizedBox(
                    height: 10.h,
                  )
                : const SizedBox.shrink(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(Assets.svg.ribbon),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(subscriptionTier),
                  ],
                ),
                active
                    ? Container(
                        height: 34.h,
                        width: 84.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                        child: Center(
                            child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.check,
                                size: 12.h,
                              ),
                              Text(
                                'Active',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        )),
                      )
                    : const SizedBox.shrink()
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppNaira(fontSize: 28,),
                Text.rich(
                    TextSpan(
                    text: price,
                    style: Theme.of(context).textTheme.displayLarge,
                    children: [
                      TextSpan(
                        text: '/year',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(color: const Color(0xff444444)),
                      )
                    ])),
              ],
            ),
            checkOut
                ? SizedBox(
                    height: 4.h,
                  )
                : const SizedBox.shrink(),
            checkOut
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Check it out',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 14.r,
                      )
                    ],
                  )
                : const SizedBox.shrink()
            // Text('₦50,000 /year', style: Theme.of(context).textTheme.displayLarge,),
          ],
        ),
      ),
    );
  }
}
