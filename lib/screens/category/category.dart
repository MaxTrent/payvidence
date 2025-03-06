import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/components/app_text_field.dart';
import 'package:payvidence/components/category_tile.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/providers/category_providers/current_category_provider.dart';
import 'package:payvidence/providers/category_providers/get_all_category_provider.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import '../../components/custom_shimmer.dart';
import '../../gen/assets.gen.dart';

@RoutePage(name: 'EmptyCategoryRoute')
class EmptyCategory extends ConsumerWidget {
  EmptyCategory({super.key});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCategory = ref.watch(getAllCategoryProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppTextField(
          prefixIcon: Padding(
            padding: EdgeInsets.all(16.h),
            child: SvgPicture.asset(Assets.svg.backbutton),
          ),
          hintText: 'Search for category',
          controller: _searchController,
          radius: 80,
          filled: true,
          fillColor: appGrey5,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          locator<PayvidenceAppRouter>()
              .navigateNamed(PayvidenceRoutes.addCategory);
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
          child:
              // Column(
              //   children: [
              //     CategoryTile(
              //       title: 'Bag',
              //       subtitle: 'This is one of the common categories in fashion industry as most people cherish their footwears.',
              //     ),
              //     CategoryTile(
              //       title: 'Footwear',
              //       subtitle: 'This is one of the common categories in fashion industry as most people cherish their footwears.',
              //     ),
              //     CategoryTile(
              //       title: 'Gown',
              //       subtitle: 'This is one of the common categories in fashion industry as most people cherish their footwears.',
              //     ),
              //   ],
              // )

              Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              allCategory.when(data: (data) {
                if (data.isEmpty) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'No category added!',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text('All added categories will appear here.',
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
                            buttonText: 'Add category',
                            onPressed: () {
                              locator<PayvidenceAppRouter>()
                                  .navigateNamed(PayvidenceRoutes.addCategory);
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
                              .read(getCurrentCategoryProvider.notifier)
                              .setCurrentCategory(data[index]);
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
          ),
        ),
      ),
    );
  }
}
