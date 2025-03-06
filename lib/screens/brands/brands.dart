import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payvidence/providers/brand_providers/current_brand_provider.dart';
import 'package:payvidence/providers/brand_providers/get_all_brand_provider.dart';

import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/category_tile.dart';
import '../../components/custom_shimmer.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'BrandsRoute')
class Brands extends ConsumerWidget {
  Brands({super.key});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBrand = ref.watch(getAllBrandProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppTextField(
          prefixIcon: Padding(
            padding: EdgeInsets.all(16.h),
            child: SvgPicture.asset(Assets.svg.backbutton),
          ),
          hintText: 'Search for brand',
          controller: _searchController,
          radius: 80,
          filled: true,
          fillColor: appGrey5,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          locator<PayvidenceAppRouter>()
              .navigateNamed(PayvidenceRoutes.addBrand);
        },
        backgroundColor: primaryColor2,
        child: Icon(
          Icons.add,
          size: 40.h,
        ),
      ),
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                allBrand.when(data: (data) {
                  if (data.isEmpty) {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'No brand added!',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text('All added brands will appear here.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                fontSize: 14.sp,
                              )),
                          SizedBox(
                            height: 48.h,
                          ),
                          AppButton(
                              buttonText: 'Add brand',
                              onPressed: () {
                                locator<PayvidenceAppRouter>()
                                    .navigateNamed(PayvidenceRoutes.addBrand);
                              })
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return CategoryTile(
                          title: data[index].name ?? '',
                          subtitle: data[index].description ?? '',
                          onPressed: () {
                            ref
                                .read(getCurrentBrandProvider.notifier)
                                .setCurrentBrand(data[index]);
                            locator<PayvidenceAppRouter>().back();
                          },
                        );
                      },
                      separatorBuilder: (ctx, idx) {
                        return SizedBox(
                          height: 24.h,
                        );
                      },
                      itemCount: data.length);
                }, error: (error, _) {
                  return const Text('An error has occurred');
                }, loading: () {
                  return const CustomShimmer();
                }),
              ],
            )),
      ),
    );
  }
}
