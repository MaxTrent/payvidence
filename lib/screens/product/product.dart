import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/custom_shimmer.dart';
import 'package:payvidence/components/product_tile.dart';
import 'package:payvidence/components/pull_to_refresh.dart';
import 'package:payvidence/providers/category_providers/get_all_category_provider.dart';
import 'package:payvidence/providers/product_providers/get_all_product_provider.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../providers/product_providers/current_product_provider.dart';
import '../../providers/product_providers/product_fillter_provider.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/theme_mode.dart';

@RoutePage(name: 'ProductRoute')
class Product extends HookConsumerWidget {
  final bool? forProductSelection;

  Product({super.key, this.forProductSelection = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProducts = ref.watch(getAllProductProvider);
    ValueNotifier<int?> productNumber = ValueNotifier(null);
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final searchController = useTextEditingController();
    final searchQuery = useState<String>('');

    // Debounced search listener
    useEffect(() {
      Timer? timer;
      void listener() {
        timer?.cancel();
        timer = Timer(const Duration(milliseconds: 300), () {
          searchQuery.value = searchController.text.trim();
        });
      }

      searchController.addListener(listener);
      return () {
        timer?.cancel();
        searchController.removeListener(listener);
      };
    }, [searchController]);

    Future<void> onRefresh() async {
      searchController.clear();
      searchQuery.value = '';
      await ref.refresh(getAllProductProvider.future);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: ValueListenableBuilder(
          builder: (context, value, _) {
            return Text(
              'All products (${value ?? '0'})',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(),
            );
          },
          valueListenable: productNumber,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppTextField(
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(16.h),
                      child: SvgPicture.asset(
                        Assets.svg.search,
                        colorFilter: ColorFilter.mode(
                          isDarkMode ? Colors.white : Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    hintText: 'Search for product',
                    controller: searchController,
                    radius: 80,
                    filled: true,
                    fillColor: isDarkMode ? Colors.black : appGrey5,
                  ),
                ),
                12.horizontalSpace,
                GestureDetector(
                  onTap: () {
                    FilterBottomSheet.show(context);
                  },
                  child: Container(
                    height: 48.h,
                    width: 56.w,
                    decoration: BoxDecoration(
                      color: borderColor,
                      borderRadius: BorderRadius.circular(56.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(14.h),
                      child: SvgPicture.asset(Assets.svg.filter),
                    ),
                  ),
                ),
              ],
            ),
            allProducts.when(
              data: (data) {
                // Filter products by name
                final filteredProducts = searchQuery.value.isEmpty
                    ? data
                    : data
                    .where((product) => product.name
                    ?.toLowerCase()
                    .contains(searchQuery.value.toLowerCase()) ?? false)
                    .toList();

                if (filteredProducts.isEmpty) {
                  productNumber.value = 0;
                  return Expanded(
                    child: PullToRefresh(
                      onRefresh: onRefresh,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            searchQuery.value.isEmpty
                                ? 'No product available!'
                                : 'No products found!',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            searchQuery.value.isEmpty
                                ? 'All added products will appear here.'
                                : 'Try a different search term.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 14.sp),
                          ),
                          if (searchQuery.value.isEmpty) ...[
                            SizedBox(height: 48.h),
                            AppButton(
                              buttonText: 'Add product',
                              onPressed: () {
                                locator<PayvidenceAppRouter>()
                                    .navigateNamed(PayvidenceRoutes.addProduct);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }
                productNumber.value = filteredProducts.length;

                return Expanded(
                  child: PullToRefresh(
                    onRefresh: onRefresh,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ProductTile(
                          product: filteredProducts[index],
                          ref: ref,
                          onPressed: () {
                            if (forProductSelection == true) {
                              Navigator.of(context).pop(filteredProducts[index]);
                            } else {
                              locator<PayvidenceAppRouter>().navigate(
                                  ProductDetailsRoute(
                                      product: filteredProducts[index]));
                              ref
                                  .read(getCurrentProductProvider.notifier)
                                  .setCurrentProduct(filteredProducts[index]);
                            }
                          },
                        );
                      },
                      separatorBuilder: (ctx, idx) {
                        return Column(
                          children: [SizedBox(height: 24.h)],
                        );
                      },
                      itemCount: filteredProducts.length,
                    ),
                  ),
                );
              },
              error: (error, _) {
                return Expanded(
                  child: PullToRefresh(
                    onRefresh: onRefresh,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text('An error has occurred')),
                      ],
                    ),
                  ),
                );
              },
              loading: () {
                return const CustomShimmer();
              },
            ),
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
    );
  }
}

class FilterBottomSheet extends HookConsumerWidget {
  const FilterBottomSheet._();

  static show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => const FilterBottomSheet._(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final allCategory = ref.watch(getAllCategoryProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(40.r),
          topLeft: Radius.circular(40.r),
        ),
      ),
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
                  color: isDarkMode ? Colors.black : Color(0xffd9d9d9),
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
            SizedBox(height: 38.h),
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
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Center(
              child: Text(
                'Select category you’ll like to see.',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            SizedBox(height: 40.h),
            allCategory.when(
              data: (data) {
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
                        SizedBox(height: 10.h),
                        Text(
                          'All added categories will appear here.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontSize: 14.sp),
                        ),
                        SizedBox(height: 12.h),
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
                          ref.read(productFilterProvider.notifier).removeFilter();
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
                                SvgPicture.asset(
                                  Assets.svg.shapes,
                                  colorFilter: ColorFilter.mode(
                                    isDarkMode ? Colors.white : Colors.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 16.w),
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
                              color: ref.read(productFilterProvider)['category_id'] ==
                                  data[index].id
                                  ? Colors.black
                                  : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (ctx, idx) {
                    return const Column(children: [Divider()]);
                  },
                  itemCount: data.length,
                );
              },
              error: (error, _) {
                return const Text('An error has occurred');
              },
              loading: () => ListView.builder(
                itemCount: 5,
                itemBuilder: (_, index) => CustomShimmer(height: 60.h),
              ),
            ),
          ],
        ),
      ),
    );
  }
}