import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/custom_shimmer.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/providers/business_providers/current_business_provider.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/nav_screens/homepage_vm.dart';
import '../../components/app_card.dart';
import '../../gen/assets.gen.dart';
import '../../providers/business_providers/get_all_business_provider.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'HomeScreenRoute')
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(homePageViewModel);
    final getAllBusiness = ref.watch(getAllBusinessProvider);

    ref.listen(getAllBusinessProvider, (prev, next) {
      if (next.hasValue) {
        ref
            .read(getCurrentBusinessProvider.notifier)
            .setCurrentBusiness(next.value!.last);
      }
    });
    // useEffect(() {
    //   Future.microtask(() async{
    //    await viewModel.getBusiness();
    //    if (viewModel.businessInfo == null) {
    //      locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.emptyBusiness);
    //    }
    //   });
    //   return null;
    // }, []);

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            8.verticalSpace,
            getAllBusiness.when(data: (data) {
              if (data.isEmpty) {
                locator<PayvidenceAppRouter>()
                    .navigateNamed(PayvidenceRoutes.emptyBusiness);
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(data.last.logoUrl ?? ''),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ref.watch(getCurrentBusinessProvider)?.name ??
                                '...',
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
                    onTap: () {
                      locator<PayvidenceAppRouter>()
                          .push(AllBusinessesRoute(allBusiness: data));
                    },
                    child: Container(
                      height: 40.h,
                      width: 157.w,
                      decoration: BoxDecoration(
                          color: appGrey2,
                          borderRadius: BorderRadius.circular(24.r)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Switch business',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(fontSize: 14.sp),
                            ),
                            SvgPicture.asset(Assets.svg.store),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            }, error: (error, _) {
              return const Text("Error fetching businesses");
            }, loading: () {
              return const CustomShimmer();
            }),

            SizedBox(
              height: 32.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    locator<PayvidenceAppRouter>()
                        .navigateNamed(PayvidenceRoutes.allReceipts);
                  },
                  child: AppCard(
                    text: 'Receipts',
                    icon: Assets.svg.receipt,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    locator<PayvidenceAppRouter>()
                        .navigateNamed(PayvidenceRoutes.allInvoices);
                  },
                  child: AppCard(
                    text: 'Invoices',
                    icon: Assets.svg.invoice,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    locator<PayvidenceAppRouter>()
                        .navigateNamed(PayvidenceRoutes.clients);
                  },
                  child: AppCard(
                    text: 'Clients',
                    icon: Assets.svg.client,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    locator<PayvidenceAppRouter>()
                        .navigateNamed(PayvidenceRoutes.product);
                  },
                  child: AppCard(
                    text: 'Products',
                    icon: Assets.svg.product,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 38.h,
            ),
            GestureDetector(
                onTap: ()=>
                  locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.chooseSubscriptionPlan),
                child: SvgPicture.asset(Assets.svg.subscribe)),
            SizedBox(
              height: 40.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent transactions',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Text(
                  'View all',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: 12.sp),
                ),
              ],
            ),
            SizedBox(
              height: 48.h,
            ),
            // TransactionTile(),
            // TransactionTile(),
            // TransactionTile(),
            // TransactionTile(),
            // TransactionTile(),
            // TransactionTile(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(Assets.svg.emptyTransaction),
                SizedBox(
                  height: 32.h,
                ),
                Text(
                  'No transaction yet!',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                    'Start generating receipts and invoices for your business. All transactions will show here.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontSize: 14.sp,
                        )),
              ],
            )
          ],
        ),
      )),
    );
  }
}
