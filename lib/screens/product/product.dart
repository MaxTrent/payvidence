import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/custom_shimmer.dart';
import 'package:payvidence/components/product_tile.dart';
import 'package:payvidence/components/pull_to_refresh.dart';
import 'package:payvidence/providers/category_providers/get_all_category_provider.dart';
import 'package:payvidence/providers/product_providers/get_all_product_provider.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import 'package:payvidence/utilities/animations.dart';

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
    final responsiveData = ResponsiveInherited.of(context);

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

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
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
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: responsiveData.scaleHeight(32)),
              FadeInWidget(
                delay: const Duration(milliseconds: 100),
                child: AppTextField(
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(responsiveData.scaleHeight(16)),
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
                  radius: responsiveData.largeRadius,
                  filled: true,
                  fillColor: isDarkMode ? Colors.black : appGrey5,
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(20)),
              Expanded(
                child: allProducts.when(
                  data: (data) {
                    // Filter products by name
                    final filteredProducts = searchQuery.value.isEmpty
                        ? data
                        : data
                        .where((product) => product.name
                        ?.toLowerCase()
                        .contains(searchQuery.value.toLowerCase()) ??
                        false)
                        .toList();
                
                    if (filteredProducts.isEmpty) {
                      productNumber.value = 0;
                      return PullToRefresh(
                        onRefresh: onRefresh,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height - responsiveData.scaleHeight(200),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: responsiveData.scaleHeight(80),),
                                SvgPicture.asset(
                                  Assets.svg.emptyProduct,
                                  width: responsiveData.scaleWidth(208), // Added for consistency
                                  height: responsiveData.scaleHeight(218),
                                ),
                                SizedBox(height: responsiveData.scaleHeight(40)),
                                Text(
                                  searchQuery.value.isEmpty
                                      ? 'No product yet!'
                                      : 'No products found!',
                                  style: Theme.of(context).textTheme.displayLarge,
                                ),
                                SizedBox(height: responsiveData.scaleHeight(10)),
                                Text(
                                  searchQuery.value.isEmpty
                                      ? 'Add products to your business account. All products added will show here.'
                                      : 'Try a different search term.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(fontSize: Responsive.fontSize(context, 14)),
                                ),
                                const Spacer(),
                                if (searchQuery.value.isEmpty) ...[
                                  Padding(
                                    padding: EdgeInsets.only(bottom: responsiveData.scaleHeight(14)),
                                    child: AppButton(
                                      buttonText: 'Add product',
                                      onPressed: () {
                                        locator<PayvidenceAppRouter>()
                                            .navigateNamed(PayvidenceRoutes.addProduct);
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    productNumber.value = filteredProducts.length;
                
                    return PullToRefresh(
                      onRefresh: onRefresh,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return SlideInWidget(
                            begin: const Offset(0, 0.3),
                            delay: Duration(milliseconds: 100 + (index * 50)),
                            child: GestureDetector(
                              onTap: () {
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
                              child: ProductTile(
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
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (ctx, idx) => Column(
                          children: [SizedBox(height: responsiveData.scaleHeight(24))],
                        ),
                        itemCount: filteredProducts.length,
                      ),
                    );
                  },
                  error: (error, _) {
                    return PullToRefresh(
                      onRefresh: onRefresh,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - responsiveData.scaleHeight(200),
                          child: const Center(child: Text('An error has occurred')),
                        ),
                      ),
                    );
                  },
                  loading: () {
                    return ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (ctx, idx) => SizedBox(height: responsiveData.scaleHeight(12)),
                      itemCount: 5,
                      itemBuilder: (_, index) => CustomShimmer(height: responsiveData.scaleHeight(60)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: allProducts.when(
          data: (data) {
            final filteredProducts = searchQuery.value.isEmpty
                ? data
                : data
                .where((product) => product.name
                ?.toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ??
                false)
                .toList();
            return filteredProducts.isNotEmpty
                ? FloatingActionButton(
              onPressed: () {
                locator<PayvidenceAppRouter>()
                    .navigateNamed(PayvidenceRoutes.addProduct);
              },
              backgroundColor: primaryColor2,
              child: Icon(
                Icons.add,
                size: responsiveData.scaleHeight(40),
              ),
            )
                : null;
          },
          error: (error, _) => null,
          loading: () => null,
        ),
      ),
    );
  }
}

class FilterBottomSheet extends HookConsumerWidget {
  const FilterBottomSheet._();

  static show(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(responsiveData.smallRadius * 1.5)), // Approx 30 equivalent
      ),
      builder: (context) => const FilterBottomSheet._(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final allCategory = ref.watch(getAllCategoryProvider);
    final responsiveData = ResponsiveInherited.of(context);

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(responsiveData.smallRadius * 2),
          topLeft: Radius.circular(responsiveData.smallRadius * 2),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: responsiveData.paddingHorizontal, vertical: responsiveData.scaleHeight(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(140)),
              child: Container(
                height: responsiveData.scaleHeight(5),
                width: responsiveData.scaleWidth(67),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.black : const Color(0xffd9d9d9),
                  borderRadius: BorderRadius.circular(responsiveData.smallRadius * 5),
                ),
              ),
            ),
            SizedBox(height: responsiveData.scaleHeight(38)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                Center(
                  child: Text(
                    'Filter products',
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontSize: Responsive.fontSize(context, 22),
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
            SizedBox(height: responsiveData.scaleHeight(12)),
            Center(
              child: Text(
                'Select category you’ll like to see.',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
            SizedBox(height: responsiveData.scaleHeight(40)),
            allCategory.when(
              data: (data) {
                if (data.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'No category added!',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(height: responsiveData.scaleHeight(10)),
                      Text(
                        'All added categories will appear here.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: Responsive.fontSize(context, 14)),
                      ),
                      SizedBox(height: responsiveData.scaleHeight(12)),
                    ],
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
                        padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
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
                                  width: responsiveData.scaleWidth(24), // Added for consistency
                                  height: responsiveData.scaleHeight(24),
                                ),
                                SizedBox(width: responsiveData.scaleWidth(16)),
                                Text(
                                  data[index].name ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(fontSize: Responsive.fontSize(context, 14)),
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
              loading: () => ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (ctx, idx) => SizedBox(height: responsiveData.scaleHeight(12)),
                itemCount: 5,
                itemBuilder: (_, index) => CustomShimmer(height: responsiveData.scaleHeight(60)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}