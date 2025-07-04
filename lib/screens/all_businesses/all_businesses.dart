import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/custom_shimmer.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/all_businesses/all_businesses_vm.dart';
import 'package:payvidence/utilities/animations.dart';
import '../../components/business_card.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/responsive.dart';
import '../../utilities/responsive_wrapper.dart';

@RoutePage(name: 'AllBusinessesRoute')
class AllBusinesses extends HookConsumerWidget with AutoRouteAware {
  const AllBusinesses({super.key});

  @override
  void didPopNext() {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(allBusinessesViewModel);
    final router = AutoRouter.of(context);
    final responsiveData = ResponsiveInherited.of(context);

    useEffect(() {
      void onRouteChange() {
        Future.microtask(() => viewModel.fetchAllBusinesses());
      }

      router.addListener(onRouteChange);

      Future.microtask(() => viewModel.fetchAllBusinesses());

      return () {
        router.removeListener(onRouteChange);
      };
    }, []);

    return ResponsiveWrapper(
      child: KeyboardDismissibleScaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: Column(
            children: [
              SizedBox(height: responsiveData.scaleHeight(16)),
              FadeInWidget(
                delay: const Duration(milliseconds: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All businesses',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    GestureDetector(
                      onTap: () {
                        locator<PayvidenceAppRouter>()
                            .navigateNamed(PayvidenceRoutes.addBusiness);
                      },
                      child: Text(
                        '+ Add New',
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontSize: Responsive.fontSize(context, 14), color: primaryColor2),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(32)),
              Expanded(
                child: viewModel.isLoading
                    ? ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _buildShimmerPlaceholder(context); // Pass context here
                  },
                  separatorBuilder: (ctx, idx) {
                    return SizedBox(height: responsiveData.scaleHeight(24));
                  },
                  itemCount: 3,
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
                    return SlideInWidget(
                      begin: const Offset(0, 0.3),
                      delay: Duration(milliseconds: 100 + (index * 50)),
                      child: BusinessCard(
                        business: viewModel.allBusinesses[index],
                      ),
                    );
                  },
                  separatorBuilder: (ctx, idx) {
                    return SizedBox(height: responsiveData.scaleHeight(24));
                  },
                  itemCount: viewModel.allBusinesses.length,
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerPlaceholder(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);
    return Container(
      height: responsiveData.scaleHeight(184),
      decoration: const BoxDecoration(color: appGrey1),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: responsiveData.paddingHorizontal,
            vertical: responsiveData.scaleHeight(21)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CustomShimmer(
                  height: responsiveData.scaleHeight(64),
                  width: responsiveData.scaleHeight(64),
                ),
                SizedBox(width: responsiveData.scaleWidth(12)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmer(
                      height: responsiveData.scaleHeight(20),
                      width: responsiveData.scaleWidth(150),
                    ),
                    SizedBox(height: responsiveData.scaleHeight(12)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomShimmer(
                            height: responsiveData.scaleHeight(16),
                            width: responsiveData.scaleWidth(80)),
                        SizedBox(width: responsiveData.scaleWidth(12)),
                        CustomShimmer(
                            height: responsiveData.scaleHeight(16),
                            width: responsiveData.scaleWidth(80)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            CustomShimmer(
              height: responsiveData.scaleHeight(48),
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}