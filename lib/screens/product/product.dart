import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payvidence/components/custom_shimmer.dart';
import 'package:payvidence/components/product_tile.dart';
import 'package:payvidence/providers/category_providers/get_all_category_provider.dart';
import 'package:payvidence/providers/product_providers/get_all_product_provider.dart';
import 'package:payvidence/providers/product_providers/product_fillter_provider.dart';

import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'ProductRoute')
class Product extends ConsumerWidget {
  Product({super.key});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProducts = ref.watch(getAllProductProvider);
    ValueNotifier<int?> productNumber = ValueNotifier(null);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: ValueListenableBuilder(
          builder: (context, value, _) {
            return Text(
              'All products (${value ?? ''})',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(),
            );
          },
          valueListenable: productNumber,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 32.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppTextField(
                  width: 282.w,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: SvgPicture.asset(Assets.svg.search),
                  ),
                  hintText: 'Search for product',
                  controller: _searchController,
                  radius: 80,
                  filled: true,
                  fillColor: appGrey5,
                  appBorderColor: Colors.transparent,
                ),
                GestureDetector(
                  onTap: () {
                    FilterBottomSheet.show(context);
                  },
                  child: Container(
                    height: 48.h,
                    width: 56.w,
                    decoration: BoxDecoration(
                        color: borderColor,
                        borderRadius: BorderRadius.circular(56.r)),
                    child: Padding(
                      padding: EdgeInsets.all(14.h),
                      child: SvgPicture.asset(Assets.svg.filter),
                    ),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 72.h,),
            // SvgPicture.asset(Assets.svg.emptyProduct),
            // SizedBox(height: 40.h,),
            // Text('No product yet!', style: Theme.of(context).textTheme.displayLarge,),
            // SizedBox(height: 10.h,),
            // Text('Add products to your business account. All products added will show here.',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, ))
            allProducts.when(data: (data) {
              if (data.isEmpty) {
                productNumber.value = 0;

                return const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("No products available"),
                    ],
                  ),
                );
              }
              productNumber.value = data.length;

              return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ProductTile(
                      product: data[index],
                      ref: ref,
                    );
                  },
                  separatorBuilder: (ctx, idx) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 24.h,
                        ),
                      ],
                    );
                  },
                  itemCount: data.length);
            }, error: (error, _) {
              return const Text('An error has occurred');
            }, loading: () {
              return const CustomShimmer();
            })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          locator<PayvidenceAppRouter>()
              .navigateNamed(PayvidenceRoutes.addProduct);
        },
        backgroundColor: primaryColor2,
        child: Icon(
          Icons.add,
          size: 40.h,
        ),
      ),
      // AppButton(buttonText: 'Add product', onPressed: (){
      //   context.push(AppRoutes.addProduct);
      // }),
    );
  }

// Future<dynamic> buildFilterBottomSheet(BuildContext context, WidgetRef ref) {
//   return showModalBottomSheet(
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       clipBehavior: Clip.none,
//       context: context,
//       builder: (context) {
//         final allCategory = ref.watch(getAllCategoryProvider);
//         return Container(
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                   topRight: Radius.circular(40.r),
//                   topLeft: Radius.circular(40.r))),
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 140.w),
//                   child: Container(
//                     height: 5.h,
//                     width: 67.w,
//                     decoration: BoxDecoration(
//                       color: const Color(0xffd9d9d9),
//                       borderRadius: BorderRadius.circular(100.r),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 38.h,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const SizedBox.shrink(),
//                     Center(
//                       child: Text(
//                         'Filter products',
//                         style: Theme.of(context)
//                             .textTheme
//                             .displayLarge!
//                             .copyWith(
//                               fontSize: 22.sp,
//                               fontWeight: FontWeight.w600,
//                             ),
//                       ),
//                     ),
//                     GestureDetector(
//                         onTap: () => Navigator.of(context).pop(),
//                         child: const Icon(
//                           Icons.close,
//                         ))
//                   ],
//                 ),
//                 SizedBox(
//                   height: 12.h,
//                 ),
//                 Center(
//                   child: Text(
//                     'Select category you’ll like to see.',
//                     style: Theme.of(context).textTheme.displaySmall,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 40.h,
//                 ),
//                 allCategory.when(data: (data) {
//                   if (data.isEmpty) {
//                     return Expanded(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             'No category added!',
//                             style: Theme.of(context).textTheme.displayLarge,
//                           ),
//                           SizedBox(
//                             height: 10.h,
//                           ),
//                           Text('All added categories will appear here.',
//                               textAlign: TextAlign.center,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .displaySmall!
//                                   .copyWith(
//                                     fontSize: 14.sp,
//                                   )),
//                           SizedBox(
//                             height: 48.h,
//                           ),
//                           AppButton(
//                               buttonText: 'Add category',
//                               onPressed: () {
//                                 locator<PayvidenceAppRouter>().navigateNamed(
//                                     PayvidenceRoutes.addCategory);
//                               })
//                         ],
//                       ),
//                     );
//                   }
//                   return ListView.separated(
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         return GestureDetector(
//                           onTap: () {
//                             if (ref.read(
//                                     productFilterProvider)['category_id'] ==
//                                 data[index].id) {
//                               ref
//                                   .read(productFilterProvider.notifier)
//                                   .removeFilter();
//                             } else {
//                               ref
//                                   .read(productFilterProvider.notifier)
//                                   .setKey('category_id', data[index].id);
//                             }
//                             ref
//                                 .read(getAllProductProvider.notifier)
//                                 .setFilter();
//                           },
//                           child: Padding(
//                             padding: EdgeInsets.symmetric(vertical: 24.h),
//                             child: Row(
//                               mainAxisAlignment:
//                                   MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     SvgPicture.asset(Assets.svg.shapes),
//                                     SizedBox(
//                                       width: 16.w,
//                                     ),
//                                     Text(
//                                       data[index].name ?? '',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .displaySmall!
//                                           .copyWith(fontSize: 14.sp),
//                                     ),
//                                   ],
//                                 ),
//                                 if (ref.read(productFilterProvider)[
//                                         'category_id'] ==
//                                     data[index].id)
//                                   Icon(Icons.check)
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                       separatorBuilder: (ctx, idx) {
//                         return const Column(
//                           children: [
//                             Divider(),
//                           ],
//                         );
//                       },
//                       itemCount: data.length);
//                 }, error: (error, _) {
//                   return const Text('An error has occurred');
//                 }, loading: () {
//                   return const CustomShimmer();
//                 }),
//               ],
//             ),
//           ),
//         );
//       });
// }
}

class FilterBottomSheet extends ConsumerWidget {
  static show(
    BuildContext context,
  ) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) {
          return const FilterBottomSheet._();
        });
  }

  const FilterBottomSheet._();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCategory = ref.watch(getAllCategoryProvider);
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(40.r), topLeft: Radius.circular(40.r))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                    'Filter products',
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
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
                'Select category you’ll like to see.',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
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
                        height: 12.h,
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (ref.read(productFilterProvider)['category_id'] ==
                            data[index].id) {
                          ref
                              .read(productFilterProvider.notifier)
                              .removeFilter();
                        } else {
                          ref
                              .read(productFilterProvider.notifier)
                              .setKey('category_id', data[index].id);
                        }

                        ref.read(getAllProductProvider.notifier).setFilter();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(Assets.svg.shapes),
                                SizedBox(
                                  width: 16.w,
                                ),
                                Text(
                                  data[index].name ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(fontSize: 14.sp),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.check,
                              color: ref.read(productFilterProvider)[
                                          'category_id'] ==
                                      data[index].id
                                  ? Colors.black
                                  : Colors.transparent,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (ctx, idx) {
                    return const Column(
                      children: [
                        Divider(),
                      ],
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
    );
  }
}
