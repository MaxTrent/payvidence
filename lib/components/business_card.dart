import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/gen/assets.gen.dart';
import 'package:payvidence/providers/business_providers/current_business_provider.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';
import '../constants/app_colors.dart';
import '../model/business_model.dart';
import '../shared_dependency/shared_dependency.dart';
import '../utilities/theme_mode.dart';
import 'app_button.dart';

class BusinessCard extends HookConsumerWidget {
  const BusinessCard({
    required this.business,
    super.key,
  });

  final Business business;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBusiness = ref.watch(getCurrentBusinessProvider);
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;


    return Container(
      height: 184.h,
      decoration:  BoxDecoration(color: isDarkMode?const Color(0xFF444444) : appGrey1),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 21.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                locator<PayvidenceAppRouter>().push(
                    BusinessDetailRoute(businessId: business.id ?? ''));
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32.r,
                    backgroundImage:
                        business.logoUrl != null && business.logoUrl!.isNotEmpty
                            ? NetworkImage(business.logoUrl!)
                            : null,
                    backgroundColor:
                        business.logoUrl != null && business.logoUrl!.isNotEmpty
                            ? null
                            : Colors.black,
                    onBackgroundImageError: (exception, stackTrace) {},
                    child: business.logoUrl == null || business.logoUrl!.isEmpty
                        ? const Icon(
                            Icons.business,
                            color: Colors.white,
                            size: 32,
                          )
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business.name ?? '',
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: isDarkMode? Colors.white: Colors.black),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(Assets.svg.library, colorFilter: ColorFilter.mode(isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn),),
                          SizedBox(width: 3.w),
                          Text(

                            '${business.noOfReceipts} receipts',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 14.sp, color: isDarkMode ? Colors.white : Colors.black),

                          ),
                          SizedBox(width: 12.w),
                          SvgPicture.asset(Assets.svg.library, colorFilter: ColorFilter.mode(isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn),),
                          SizedBox(width: 3.w),
                          Text(

                            '${business.noOfInvoices} invoices',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 14.sp, color: isDarkMode ? Colors.white : Colors.black),

                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppButton(
              buttonText: 'Switch to business',
              isDisabled: business.id == currentBusiness?.id,
              onPressed: () {
                ref
                    .read(getCurrentBusinessProvider.notifier)
                    .setCurrentBusiness(business);
              },
            ),
          ],
        ),
      ),
    );
  }
}
