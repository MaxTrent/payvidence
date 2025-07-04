import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/components/app_text_field.dart';
import 'package:payvidence/components/category_tile.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
import 'package:payvidence/components/simple_bottom_sheet.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/providers/category_providers/current_category_provider.dart';
import 'package:payvidence/providers/category_providers/get_all_category_provider.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/toast_service.dart';
import '../../components/custom_shimmer.dart';
import '../../gen/assets.gen.dart';
import '../../utilities/responsive.dart';
import '../../utilities/responsive_wrapper.dart';
import '../../utilities/theme_mode.dart';

@RoutePage(name: 'EmptyCategoryRoute')
class EmptyCategory extends HookConsumerWidget {
  EmptyCategory({super.key});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final responsiveData = ResponsiveInherited.of(context);

    final allCategory = ref.watch(getAllCategoryProvider);

    return ResponsiveWrapper(
      child: KeyboardDismissibleScaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: AppTextField(
            prefixIcon: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.all(responsiveData.scaleHeight(16)),
                child: SvgPicture.asset(
                  Assets.svg.backbutton,
                  colorFilter: ColorFilter.mode(
                      isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn),
                ),
              ),
            ),
            hintText: 'Search for category',
            controller: _searchController,
            radius: responsiveData.largeRadius,
            filled: isDarkMode ? false : true,
            appBorderColor: isDarkMode ? Colors.white : Colors.transparent,
            fillColor: isDarkMode ? Colors.black : appGrey5,
          ),
        ),
        floatingActionButton: allCategory.maybeWhen(
          data: (data) => data.isNotEmpty ? FloatingActionButton(
            onPressed: () {
              locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.addCategory);
            },
            backgroundColor: primaryColor2,
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: responsiveData.scaleHeight(40),
            ),
          ) : null,
          orElse: () => null,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                allCategory.when(
                  loading: () => Expanded(
                    child: ListView.separated(
                      itemCount: 6,
                      separatorBuilder: (context, index) => SizedBox(height: responsiveData.scaleHeight(16)),
                      itemBuilder: (context, index) => CustomShimmer(
                        height: responsiveData.scaleHeight(60),
                        width: double.infinity,
                      ),
                    ),
                  ),
                  error: (error, stack) => Expanded(
                    child: Center(
                      child: Text(
                        'Failed to load categories',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ),
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
                            SizedBox(
                              height: responsiveData.scaleHeight(10),
                            ),
                            Text(
                              'All added categories will appear here.',
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
                              buttonText: 'Add category',
                              onPressed: () {
                                locator<PayvidenceAppRouter>()
                                    .navigateNamed(PayvidenceRoutes.addCategory);
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
                              color: appRed,
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
                                  title: 'Delete Category',
                                  subtitle: 'Are you sure you want to delete this category?',
                                  height: responsiveData.scaleHeight(500),
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        if (data[index].id != null) {
                                          try {
                                            await ref.read(getAllCategoryProvider.notifier).deleteCategory(data[index].id!);
                                          } catch (e) {
                                            ToastService.showErrorSnackBar('Failed to delete category. It is associated with a receipt/invoice');
                                          }
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color:appRed,
                                            ),
                                            SizedBox(width: responsiveData.scaleWidth(16)),
                                            Text(
                                              'Delete',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall!
                                                  .copyWith(
                                                fontSize: Responsive.fontSize(context, 14),
                                                color: appRed,
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
                                    .read(getCurrentCategoryProvider.notifier)
                                    .setCurrentCategory(data[index]);
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}