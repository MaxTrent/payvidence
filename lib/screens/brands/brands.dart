import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/providers/brand_providers/current_brand_provider.dart';
import 'package:payvidence/providers/brand_providers/get_all_brand_provider.dart';
import 'package:payvidence/utilities/toast_service.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/category_tile.dart';
import '../../components/custom_shimmer.dart';
import '../../components/simple_bottom_sheet.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/responsive.dart';
import '../../utilities/responsive_wrapper.dart';
import '../../utilities/theme_mode.dart';

@RoutePage(name: 'BrandsRoute')
class Brands extends HookConsumerWidget {
  Brands({super.key});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final responsiveData = ResponsiveInherited.of(context);
    final allBrand = ref.watch(getAllBrandProvider);

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: AppTextField(
            prefixIcon: Padding(
              padding: EdgeInsets.all(responsiveData.scaleHeight(16)),
              child: GestureDetector(
                onTap: ()=>Navigator.of(context).pop(),
                child: SvgPicture.asset(
                  Assets.svg.backbutton,
                  colorFilter: ColorFilter.mode(
                      isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn),
                ),
              ),
            ),
            hintText: 'Search for brand',
            controller: _searchController,
            radius: responsiveData.largeRadius,
            filled: true,
            fillColor: isDarkMode ? Colors.black : appGrey5,
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
            size: responsiveData.scaleHeight(40),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
            child: Column(
              children: [
                allBrand.when(
                  data: (data) {
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
                              height: responsiveData.scaleHeight(10),
                            ),
                            Text(
                              'All added brands will appear here.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: Responsive.fontSize(context, 14)),
                            ),
                            SizedBox(
                              height: responsiveData.scaleHeight(48),
                            ),
                            AppButton(
                              buttonText: 'Add brand',
                              onPressed: () {
                                locator<PayvidenceAppRouter>()
                                    .navigateNamed(PayvidenceRoutes.addBrand);
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(data[index].id ?? index.toString()),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: responsiveData.scaleWidth(20)),
                              color: Colors.red,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: responsiveData.scaleHeight(24),
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              final result = await showModalBottomSheet<bool>(
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                clipBehavior: Clip.none,
                                context: context,
                                builder: (context) => SimpleBottomSheet(
                                  isDarkMode: isDarkMode,
                                  title: 'Delete Brand',
                                  subtitle: 'Are you sure you want to delete this brand?',
                                  height: 300,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        if (data[index].id != null) {
                                          try {
                                            await ref.read(getAllBrandProvider.notifier).deleteBrand(data[index].id!);
                                          } catch (e) {
                                            ToastService.showErrorSnackBar('Failed to delete brand. It is associated with a receipt/invoice');
                                          }
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            SizedBox(width: responsiveData.scaleWidth(16)),
                                            Text(
                                              'Delete',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall!
                                                  .copyWith(
                                                fontSize: Responsive.fontSize(context, 14),
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Divider(height: responsiveData.scaleHeight(1)),
                                    GestureDetector(
                                      onTap: () => Navigator.of(context).pop(false),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.cancel,
                                              color: isDarkMode ? Colors.white : Colors.black,
                                            ),
                                            SizedBox(width: responsiveData.scaleWidth(16)),
                                            Text(
                                              'Cancel',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall!
                                                  .copyWith(fontSize: Responsive.fontSize(context, 14)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              return result ?? false;
                            },
                            child: CategoryTile(
                              title: data[index].name ?? '',
                              subtitle: data[index].description ?? '',
                              onPressed: () {
                                ref
                                    .read(getCurrentBrandProvider.notifier)
                                    .setCurrentBrand(data[index]);
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        },
                        separatorBuilder: (ctx, idx) {
                          return SizedBox(
                            height: responsiveData.scaleHeight(24),
                          );
                        },
                        itemCount: data.length,
                      ),
                    );
                  },
                  error: (error, _) {
                    return const Text('An error has occurred');
                  },
                  loading: () {
                    return const CustomShimmer();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}