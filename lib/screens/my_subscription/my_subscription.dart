import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/components/pull_to_refresh.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/my_subscription/my_subscription_vm.dart';
import 'package:payvidence/utilities/extensions.dart';
import '../../components/subscription_card.dart';
import '../../gen/assets.gen.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'MySubscriptionRoute')
class MySubscription extends HookConsumerWidget {
  const MySubscription({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(mySubscriptionViewModel);

    useEffect(() {
      viewModel.fetchSubscriptions();
      return null;
    }, []);

    // final isActiveSubscription = viewModel.subInfo?.status == "active";
    Future<void> onRefresh() async {
      await viewModel.fetchSubscriptions();
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My subscription',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(
              height: 24.h,
            ),
            Expanded(
              child: PullToRefresh(
                onRefresh: onRefresh,
                child: ListView(
                  children: [
                    SubscriptionCard(
                      subscriptionTier:
                          viewModel.subInfo?.plan.name ?? "Starter subscription plan",
                      price: viewModel.subInfo?.plan.amount ?? '0',
                      checkOut: false,
                      active: true,
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Current plan',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
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
                            SizedBox(
                              width: 6.w,
                            ),
                            Text(
                              viewModel.subInfo?.plan.name ?? 'Starter',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    viewModel.subInfo?.startDate == null
                        ? const SizedBox.shrink()
                        : SizedBox(
                            height: 18.h,
                          ),
                    viewModel.subInfo?.startDate == null
                        ? const SizedBox.shrink()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Subscription date',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              Text(
                                viewModel.subInfo!.startDate.toFormattedString(),
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ],
                          ),
                    viewModel.subInfo?.startDate == null
                        ? const SizedBox.shrink()
                        : SizedBox(
                            height: 18.h,
                          ),
                    viewModel.subInfo?.expiryDate == null
                        ? const SizedBox.shrink()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Expiration date',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                              Text(
                                viewModel.subInfo?.expiryDate.toFormattedString() ??
                                    "Not available",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 40.h,
                    ),
                    viewModel.subInfo == null
                        ? const SizedBox.shrink()
                        : _buildSubscriptionHistory(context, viewModel),
                    AppButton(
                        buttonText: 'Manage subscription',
                        onPressed: () {
                          _buildManageSubscriptionBottomSheet(context);
                        }),
                    SizedBox(
                      height: 26.h,
                    ),
                    GestureDetector(
                        onTap: () {
                          _buildCancelSubBottomSheet(context);
                        },
                        child: Center(
                            child: Text(
                              'Cancel subscription',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(color: appRed),
                            )))
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionHistory(
      BuildContext context, MySubscriptionViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subscription history',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        SizedBox(
          height: 12.h,
        ),
        ...viewModel.expiredSubscriptions.map(
          (sub) => ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              height: 56.h,
              width: 56.w,
              decoration: const BoxDecoration(
                color: primaryColor4,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(14.h),
                child: SvgPicture.asset(Assets.svg.ribbon),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sub.plan.name,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: 16.sp),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  '₦${sub.plan.amount}',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: 16.sp),
                ),
              ],
            ),
            trailing: Text(
              sub.startDate.toFormattedString(),
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 14.sp, color: const Color(0xff979797)),
            ),
          ),
        ),

        // SizedBox(height: 36.h,),
        //
        // ListTile(
        //   contentPadding: EdgeInsets.zero,
        //   leading: Container(
        //     height: 56.h,
        //     width: 56.w,
        //     decoration: const BoxDecoration(
        //       color: primaryColor4,
        //       shape: BoxShape.circle,
        //     ),
        //     child: Padding(
        //       padding:  EdgeInsets.all(14.h),
        //       child: SvgPicture.asset(Assets.svg.ribbon),
        //     ),
        //   ),
        //   title: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text('Business Plan', style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 16.sp),),
        //       SizedBox(height: 8.h,),
        //       Text('₦10,000.00', style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 16.sp),),
        //     ],
        //   ),
        //   trailing: Text('Sept. 2, 2023', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, color: const Color(0xff979797)),),
        // ),
        SizedBox(
          height: 60.h,
        ),
      ],
    );
  }

  Future<dynamic> _buildManageSubscriptionBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        clipBehavior: Clip.none,
        context: context,
        builder: (context) {
          return Container(
            height: 398.h,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.r),
                    topLeft: Radius.circular(40.r))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Stack(
                children: [
                  ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 140.w),
                        child: Container(
                          height: 5.h,
                          width: 67.w,
                          decoration: BoxDecoration(
                            color: const Color(0xffd9d9d9),
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 38.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox.shrink(),
                          Center(
                            child: Text(
                              'Manage subscription',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(
                                Icons.close,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Center(
                        child: Text(
                          'What will you like to do?',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Row(
                          children: [
                            SvgPicture.asset(Assets.svg.upgradeplan),
                            SizedBox(
                              width: 16.w,
                            ),
                            Text(
                              'Upgrade plan',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          locator<PayvidenceAppRouter>().navigateNamed(
                              PayvidenceRoutes.chooseSubscriptionPlan);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: Row(
                            children: [
                              SvgPicture.asset(Assets.svg.otherplans),
                              SizedBox(
                                width: 16.w,
                              ),
                              Text(
                                'Check out other plans',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: 1.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Row(
                          children: [
                            SvgPicture.asset(Assets.svg.renewplan),
                            SizedBox(
                              width: 16.w,
                            ),
                            Text(
                              'Renew plan',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1.h,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<dynamic> _buildCancelSubBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        clipBehavior: Clip.none,
        context: context,
        builder: (context) {
          return Container(
            height: 398.h,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.r),
                    topLeft: Radius.circular(40.r))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Stack(
                children: [
                  ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 140.w),
                        child: Container(
                          height: 5.h,
                          width: 67.w,
                          decoration: BoxDecoration(
                            color: const Color(0xffd9d9d9),
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 38.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox.shrink(),
                          Center(
                            child: Text(
                              'Cancel subscription',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(
                                Icons.close,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Center(
                        child: Text(
                          'There will be no refund for cancelled\n\nsubscription. Are you sure you want to cancel?',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      SizedBox(
                        height: 47.h,
                      ),
                      AppButton(
                        buttonText: 'Yes, cancel subscription',
                        onPressed: () {},
                        backgroundColor: appRed,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      AppButton(
                        buttonText: 'Cancel',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        backgroundColor: Colors.transparent,
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
