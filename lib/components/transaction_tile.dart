import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../constants/app_colors.dart';
import '../gen/assets.gen.dart';
import 'app_naira.dart';
//TODO: Display Naira properly

class TransactionTile extends StatelessWidget {
  String productName;
  String unitSold;
  String dateTime;
  String amount;
  String receiptOrInvoice;

  TransactionTile(
      {super.key,
      required this.amount,
      required this.dateTime,
      required this.productName,
      required this.receiptOrInvoice,
      required this.unitSold});

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 101.h,
      // width: double.infinity,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 72.h,
            width: 72.h,
            decoration: const BoxDecoration(color: Colors.black),
          ),
          SizedBox(
            width: 14.w,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(
                  height: 6.h,
                ),
                Row(
                  children: [
                    Text('$unitSold units sold',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 14.sp, color: appGrey4)),
                    SizedBox(
                      width: 10.w,
                    ),
                    Container(
                      height: 6.h,
                      width: 6.h,
                      decoration: BoxDecoration(
                          color: appGrey4,
                          borderRadius: BorderRadius.circular(24.r)),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(dateTime,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 14.sp, color: appGrey4)),
                  ],
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const AppNaira(fontSize: 14,),
                        Text(amount,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontSize: 14.sp)),
                      ],
                    ),
                    Container(
                      height: 23.h,
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 5.h),
                      // width: 71.w,
                      decoration: BoxDecoration(
                          color: primaryColor2.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            receiptOrInvoice.trim().toLowerCase() == 'receipt'
                                ? Assets.svg.receipt
                                : Assets.svg.invoice,
                            colorFilter: const ColorFilter.mode(
                                primaryColor2, BlendMode.dstIn),
                          ),
                          Text(
                            receiptOrInvoice,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    fontSize: 12.sp, color: primaryColor2),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


