import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/model/product_model.dart';
import 'package:payvidence/providers/product_providers/current_product_provider.dart';
import 'package:payvidence/providers/product_providers/get_all_product_provider.dart';
import 'package:payvidence/utilities/extensions.dart';
import '../../components/app_dot.dart';
import '../../components/app_naira.dart';
import '../../components/loading_dialog.dart';
import '../../constants/app_colors.dart';
import '../../data/network/api_response.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/theme_mode.dart';
import '../../utilities/toast_service.dart';

@RoutePage(name: 'ProductDetailsRoute')
class ProductDetails extends HookConsumerWidget {
  final Product product;

  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final Product? currentProduct = ref.watch(getCurrentProductProvider);
    Future<void> deleteProduct() async {
      Navigator.of(context).pop();
      if (!context.mounted) return;
      LoadingDialog.show(context);
      try {
        final response = await ref
            .read(getAllProductProvider.notifier)
            .deleteProduct(currentProduct?.id ?? '');
        if (!context.mounted) return;
        Navigator.of(context).pop();
        ToastService.showSnackBar("Product deleted successfully");
        ref.invalidate(getAllProductProvider);
        Future.delayed(const Duration(seconds: 2), () {
          if (!context.mounted) return;
          context.router.back();
          //  context.router.pushAndPopUntil(const HomePageRoute(), predicate: (route)=>route.settings.name == '/');
        });
      } on ApiErrorResponseV2 catch (e) {
        Navigator.of(context).pop();
        String errorMessage = e.message ?? 'An unknown error has occurred!';
        ToastService.showErrorSnackBar(errorMessage);
      } on DioException catch (e) {
        Navigator.of(context).pop();
        ToastService.showErrorSnackBar(
            e.response?.data['message'] ?? 'An unknown error has occurred!!!');
      } catch (e) {
        print(e);
        Navigator.of(context).pop();
        ToastService.showErrorSnackBar('An unknown error has occurred!');
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 320.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: currentProduct?.logoUrl != null
                        ? NetworkImage(currentProduct!.logoUrl!)
                        : AssetImage(Assets.png.payvidenceLogo.path) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        18.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: 48.h,
                                width: 48.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(56.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.h),
                                  child: SvgPicture.asset(Assets.svg.backArrow),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _buildConfirmDeleteBottomSheet(
                                    context, deleteProduct);
                              },
                              child: Container(
                                height: 48.h,
                                width: 48.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(56.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.h),
                                  child: SvgPicture.asset(Assets.svg.delete),
                                ),
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            locator<PayvidenceAppRouter>().navigate(
                                AddProductRoute(product: currentProduct));
                          },
                          child: Container(
                            height: 40.h,
                            width: 139.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(32.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 12.w),
                              child: Row(
                                children: [
                                  SvgPicture.asset(Assets.svg.edit),
                                  Text(
                                    'Edit product',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        18.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24.h,
                    ),
                    Text(
                      currentProduct?.name?.capitalize() ?? '',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontSize: 22.sp,
                          ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(currentProduct?.description?.capitalize() ?? '',
                        style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                            '${currentProduct?.category?.name?.capitalize() ?? ''}   ',
                            style: Theme.of(context).textTheme.displaySmall),
                        AppDot(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        Text(
                            '   ${currentProduct?.brand?.name?.capitalize() ?? ''}',
                            style: Theme.of(context).textTheme.displaySmall),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      children: [
                        AppNaira(fontSize: 28, color: isDarkMode ? Colors.white:Colors.black,),
                        Text(
                          '${currentProduct?.price}',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(Assets.svg.star),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          '${currentProduct?.quantitySold} units sold',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        AppDot(
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          '${currentProduct?.quantityAvailable} units left',
                          style: Theme.of(context).textTheme.displaySmall,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        locator<PayvidenceAppRouter>().navigate(
                            UpdateQuantityRoute(product: currentProduct!));
                      },
                      child: Text(
                        'Update quantity',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                color: primaryColor2,
                                decoration: TextDecoration.underline),
                      ),
                    ),
                    SizedBox(
                      height: 73.h,
                    ),
                    AppButton(
                      buttonText: 'Record sale',
                      onPressed: () {},
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    AppButton(
                      buttonText: 'Generate invoice',
                      onPressed: () {},
                      backgroundColor: Colors.transparent,
                      textColor: primaryColor2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _buildConfirmDeleteBottomSheet(
      BuildContext context, void Function() onDelete) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        clipBehavior: Clip.none,
        context: context,
        builder: (context) {
          return Container(
            height: 398.h,
            decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.r),
                    topLeft: Radius.circular(40.r))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Stack(
                children: [
                  ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
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
                              'Confirm delete',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
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
                          'Are you sure you want to delete this product?\n\nAll details and statistics will be gone.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      SizedBox(
                        height: 47.h,
                      ),
                      AppButton(
                        buttonText: 'Delete product',
                        onPressed: onDelete,
                        backgroundColor: appRed,
                        textColor: Colors.white,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      AppButton(
                        buttonText: 'Cancel',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        backgroundColor: Colors.transparent,
                        textColor: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
