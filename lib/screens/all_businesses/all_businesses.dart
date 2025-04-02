import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/custom_shimmer.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/all_businesses/all_businesses_vm.dart';
import '../../components/business_card.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'AllBusinessesRoute')
class AllBusinesses extends HookConsumerWidget with AutoRouteAware {
  const AllBusinesses({super.key});

  @override
  void didPopNext() {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(allBusinessesViewModel);
    final router = AutoRouter.of(context);

    useEffect(() {
      void onRouteChange() {
        viewModel.fetchAllBusinesses();
      }

      router.addListener(onRouteChange);

      viewModel.fetchAllBusinesses();

      return () {
        router.removeListener(onRouteChange);
      };
    }, []);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All businesses',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                GestureDetector(
                  onTap: () {
                    locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.addBusiness);
                  },
                  child: Text(
                    '+ Add New',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 14.sp, color: primaryColor2),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            Expanded(
              child: viewModel.isLoading
                  ? ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _buildShimmerPlaceholder();
                },
                separatorBuilder: (ctx, idx) {
                  return SizedBox(height: 24.h);
                },
                itemCount: 3, // Show 3 shimmer placeholders
              )
                  : viewModel.allBusinesses.isEmpty
                  ? Center(
                child: Text(
                  'No businesses found.',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              )
                  : ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return BusinessCard(
                    business: viewModel.allBusinesses[index],
                  );
                },
                separatorBuilder: (ctx, idx) {
                  return SizedBox(height: 24.h);
                },
                itemCount: viewModel.allBusinesses.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Container(
      height: 184.h,
      decoration: const BoxDecoration(color: appGrey1),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 21.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomShimmer(
                  height: 64.h,
                  width: 64.h,
                  // borderRadius: BorderRadius.circular(32.r),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmer(
                      height: 20.h,
                      width: 150.w,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomShimmer(height: 16.h, width: 80.w),
                        SizedBox(width: 12.w),
                        CustomShimmer(height: 16.h, width: 80.w),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            CustomShimmer(
              height: 48.h,
              width: double.infinity,
              // borderRadius: BorderRadius.circular(8.r),
            ),
          ],
        ),
      ),
    );
  }
}