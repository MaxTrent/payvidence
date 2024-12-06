import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/constants/app_colors.dart';

import '../../components/app_card.dart';
import '../../gen/assets.gen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Colors.black,
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Keekee Store',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontSize: 14.sp),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(Assets.svg.ribbon),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              'Starter plan',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: 12.sp),
                            ),

                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: 15.w,
                ),
                GestureDetector(
                  onTap: (){
                    context.push('/emptyBusiness');
                  },
                  child: Container(
                    height: 40.h,
                    width: 157.w,
                    decoration: BoxDecoration(
                      color: appGrey2,
                      borderRadius: BorderRadius.circular(24.r)
                    ),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Switch business', style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontSize: 14.sp),),
                          SvgPicture.asset(Assets.svg.store),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 32.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppCard(text: 'Receipts',
                icon: Assets.svg.receipt,),
                AppCard(text: 'Invoices',
                  icon: Assets.svg.invoice,),
                AppCard(text: 'Clients',
                  icon: Assets.svg.client,),
                AppCard(text: 'Products',
                  icon: Assets.svg.product,),
              ],
            ),
            SizedBox(height: 38.h,),
            SvgPicture.asset(Assets.svg.subscribe),
            SizedBox(height: 40.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent transactions', style: Theme.of(context).textTheme.displayMedium,),
                Text('View all', style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 12.sp ),),
              ],
            ),
            SizedBox(height: 48.h,),
            TransactionTile(),
            TransactionTile(),
            TransactionTile(),
            TransactionTile(),
            TransactionTile(),
            TransactionTile(),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     SvgPicture.asset(Assets.svg.emptyTransaction),
            //     SizedBox(height: 32.h,),
            //     Text('No transaction yet!', style: Theme.of(context).textTheme.displayLarge,),
            //               SizedBox(height: 10.h,),
            //     Text('Start generating receipts and invoices for your business. All transactions will show here.',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, )),
            //   ],
            // )
          ],
        ),
      )),
    );
  }
}

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('₦220,000.00', style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 14.sp)),
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

