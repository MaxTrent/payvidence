import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payvidence/providers/business_providers/current_business_provider.dart';

import '../constants/app_colors.dart';
import '../gen/assets.gen.dart';
import '../model/business_model.dart';
import '../routes/payvidence_app_router.dart';
import '../routes/payvidence_app_router.gr.dart';
import '../shared_dependency/shared_dependency.dart';
import 'app_button.dart';

class BusinessCard extends ConsumerWidget {
  const BusinessCard({
    required this.business,
    super.key,
  });

  final Business business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBusiness = ref.watch(getCurrentBusinessProvider);
   
    return Container(
      height: 184.h,
      decoration: const BoxDecoration(color: appGrey1),
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
                SizedBox(
                  width: 12.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      business.name ?? '',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(Assets.svg.library),
                        SizedBox(
                          width: 3.w,
                        ),
                        Text('20 receipts',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 14.sp)),
                        SizedBox(
                          width: 12.w,
                        ),
                        SvgPicture.asset(Assets.svg.library),
                        SizedBox(
                          width: 3.w,
                        ),
                        Text('20 invoices',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 14.sp))
                      ],
                    )
                  ],
                )
              ],
            ),
            AppButton(
                buttonText: 'Switch to business',
                isDisabled: business == currentBusiness,
                onPressed: () {
                  ref.read(getCurrentBusinessProvider.notifier).setCurrentBusiness(business);
                })
          ],
        ),
      ),
    );
  }
}
