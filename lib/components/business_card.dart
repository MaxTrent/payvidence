import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../gen/assets.gen.dart';
import '../routes/app_routes.dart';
import 'app_button.dart';


class BusinessCard extends StatelessWidget {
  BusinessCard({
    required this.businessName,
    required this.numberOfInvoices,
    required this.numberOfReceipts,
    super.key,
  });

  String businessName;
  String numberOfReceipts;
  String numberOfInvoices;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 184.h,
      decoration: BoxDecoration(
          color: appGrey1
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 21.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 32.r,
                ),
                SizedBox(width: 12.w,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(businessName, style: Theme.of(context).textTheme.displayMedium,),
                    SizedBox(height: 12.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(Assets.svg.library),
                        SizedBox(width: 3.w,),
                        Text('$numberOfReceipts receipts',style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp)),
                        SizedBox(width: 12.w,),
                        SvgPicture.asset(Assets.svg.library),
                        SizedBox(width: 3.w,),
                        Text('$numberOfInvoices invoices', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp))
                      ],
                    )
                  ],
                )
              ],
            ),
            AppButton(buttonText: 'Switch to business', onPressed: (){
              context.push(AppRoutes.upgradeSubscription);
            })
          ],
        ),
      ),
    );
  }
}