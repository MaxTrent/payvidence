import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payvidence/components/app_text_field.dart';
import 'package:payvidence/constants/app_colors.dart';

import '../../gen/assets.gen.dart';

class Sales extends StatelessWidget {
  Sales({super.key});

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView(
            children: [
              Row(
                children: [
                  Container(
                    height: 45.h,
                    width: 83.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(43.r),
                        color: primaryColor2),
                    child: Center(
                        child: Text(
                      'Weekly',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(color: Colors.white),
                    )),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    height: 45.h,
                    width: 83.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(43.r),
                      // color: primaryColor2
                    ),
                    child: Center(
                        child: Text(
                      'Monthly',
                      style: Theme.of(context).textTheme.displaySmall!,
                    )),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    height: 45.h,
                    width: 83.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(43.r),
                      // color: primaryColor2
                    ),
                    child: Center(
                        child: Text(
                      'Yearly',
                      style: Theme.of(context).textTheme.displaySmall!,
                    )),
                  ),
                ],
              ),
              SizedBox(
                height: 24.h,
              ),
              AppTextField(
                hintText: '08 / 09 / 2024',
                controller: _controller,
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
              SizedBox(
                height: 36.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SalesInfoTile(
                    icon: Assets.svg.statusUp,
                    amount: '₦800K',
                    description: 'Total revenue',
                  ),
                  SalesInfoTile(
                    icon: Assets.svg.boxTick,
                    amount: '320',
                    description: 'Total sales',
                  ),
                ],
              ),
              SizedBox(
                height: 18.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SalesInfoTile(
                    icon: Assets.svg.noteText,
                    amount: '320',
                    description: 'Total receipts',
                  ),
                  SalesInfoTile(
                    icon: Assets.svg.archiveBook,
                    amount: '102',
                    description: 'Total invoices',
                  ),
                ],
              ),
              SizedBox(
                height: 36.h,
              ),
              SvgPicture.asset(Assets.svg.analytics)
            ],
          ),
        ),
      ),
    );
  }
}

class SalesInfoTile extends StatelessWidget {
  SalesInfoTile({
    required this.icon,
    required this.amount,
    required this.description,
    super.key,
  });

  String amount;
  String description;
  String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98.h,
      width: 167.w,
      decoration: BoxDecoration(
        color: const Color(0xffE3DDFF),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Padding(
        padding:
            EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h, bottom: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(48.r)),
                  child: Padding(
                    padding: EdgeInsets.all(8.h),
                    child: SvgPicture.asset(icon),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Text(
                  amount,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(fontSize: 22.sp),
                )
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(
              description,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 14.sp),
            )
          ],
        ),
      ),
    );
  }
}
