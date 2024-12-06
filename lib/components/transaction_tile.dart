import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../constants/app_colors.dart';
import '../gen/assets.gen.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 101.h,
      decoration: BoxDecoration(
          color: Colors.transparent
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 72.h,
            width: 72.h,
            decoration: BoxDecoration(
                color: Colors.black
            ),
          ),
          SizedBox(width: 14.w,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lucas Dinner Gown', style: Theme.of(context).textTheme.displayMedium,),
              SizedBox(height: 6.h,),
              Row(
                children: [
                  Text('15 units sold', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, color: appGrey4)),
                  SizedBox(width: 10.w,),
                  Container(
                    height: 6.h,
                    width: 6.h,
                    decoration: BoxDecoration(
                        color: appGrey4,
                        borderRadius: BorderRadius.circular(24.r)

                    ),
                  ),
                  SizedBox(width: 10.w,),
                  Text('Today, 8:50PM', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, color: appGrey4)),

                ],
              ),
              SizedBox(height: 8.h,),
              Row(
                  mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('₦220,000.00', style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 14.sp)),
                  SizedBox(width: 80.w),
                  Container(
                    height: 23.h,
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
                    // width: 71.w,
                    decoration: BoxDecoration(
                        color: primaryColor2.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6.r)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(Assets.svg.receipt, colorFilter: ColorFilter.mode(primaryColor2, BlendMode.dstIn),),
                        Text('Receipt', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 12.sp, color: primaryColor2),),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),

        ],
      ),
    );
  }
}

