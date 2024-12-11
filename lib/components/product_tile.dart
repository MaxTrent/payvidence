import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/components/app_button.dart';

import '../constants/app_colors.dart';
import '../gen/assets.gen.dart';
import '../routes/app_routes.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        context.push(AppRoutes.productDetails);
      },
      child: Container(
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
                Row(crossAxisAlignment: CrossAxisAlignment.center,
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
                    Text('5 units solds', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, color: appGrey4)),

                  ],
                ),
                SizedBox(height: 8.h,),
                Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('₦220,000.00', style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 14.sp)),


                  ],
                )
              ],
            ),

          ],
        ),
      ),
    );;
  }
}
