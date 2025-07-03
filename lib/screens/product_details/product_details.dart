import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/model/product_model.dart';
import 'package:payvidence/providers/product_providers/current_product_provider.dart';
import 'package:payvidence/providers/product_providers/get_all_product_provider.dart';
import 'package:payvidence/utilities/extensions.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
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
    final responsiveData = ResponsiveInherited.of(context);

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

    return ResponsiveWrapper(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: responsiveData.scaleHeight(320),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                  ),
                  child: Stack(
                    children: [
                      currentProduct?.logoUrl != null
                          ? Image.network(
                              currentProduct!.logoUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: Image.asset(
                                  Assets.png.payvidenceLogo.path,
                                  height: responsiveData.scaleHeight(450),
                                ),
                              ),
                            )
                          : Center(
                              child: Image.asset(
                                Assets.png.payvidenceLogo.path,
                                height: responsiveData.scaleHeight(150),
                              ),
                            ),
                      SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: responsiveData.scaleHeight(18)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: responsiveData.scaleHeight(48),
                                  width: responsiveData.scaleHeight(48),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(responsiveData.smallRadius * 2.8), // Approx 56.r equivalent
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(responsiveData.scaleHeight(12)),
                                    child: SvgPicture.asset(
                                      Assets.svg.backArrow,
                                      width: responsiveData.scaleWidth(24), // Added for consistency
                                      height: responsiveData.scaleHeight(24),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _buildConfirmDeleteBottomSheet(context, deleteProduct);
                                },
                                child: Container(
                                  height: responsiveData.scaleHeight(48),
                                  width: responsiveData.scaleHeight(48),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(responsiveData.smallRadius * 2.8), // Approx 56.r equivalent
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(responsiveData.scaleHeight(12)),
                                    child: SvgPicture.asset(
                                      Assets.svg.delete,
                                      width: responsiveData.scaleWidth(24), // Added for consistency
                                      height: responsiveData.scaleHeight(24),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                locator<PayvidenceAppRouter>().navigate(
                                    AddProductRoute(product: currentProduct));
                              },
                              child: Container(
                                // height: responsiveData.scaleHeight(40),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(responsiveData.smallRadius * 1.6),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: responsiveData.scaleHeight(10),
                                      horizontal: responsiveData.scaleWidth(12)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        Assets.svg.edit,
                                        width: responsiveData.scaleWidth(20),
                                        height: responsiveData.scaleHeight(20),
                                      ),
                                      SizedBox(width: responsiveData.scaleWidth(4)),
                                      Flexible(
                                        child: Text(
                                          'Edit product',
                                          style: Theme.of(context).textTheme.displaySmall,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: responsiveData.scaleHeight(18)),
                        ],
                      ),
                    ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: responsiveData.scaleHeight(24),
                      ),
                      Text(
                        currentProduct?.name?.capitalize() ?? '',
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: Responsive.fontSize(context, 22),
                        ),
                      ),
                      if (currentProduct?.description?.isNotEmpty == true) ...[
                        SizedBox(
                          height: responsiveData.scaleHeight(12),
                        ),
                        Text(
                          currentProduct!.description!.capitalize(),
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        SizedBox(
                          height: responsiveData.scaleHeight(10),
                        ),
                      ],
                      if (currentProduct?.category?.name?.isNotEmpty == true || currentProduct?.brand?.name?.isNotEmpty == true)
                        Row(
                          children: [
                            if (currentProduct?.category?.name?.isNotEmpty == true)
                              Text(
                                '${currentProduct!.category!.name!.capitalize()}   ',
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            if (currentProduct?.category?.name?.isNotEmpty == true && currentProduct?.brand?.name?.isNotEmpty == true)
                              AppDot(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            if (currentProduct?.brand?.name?.isNotEmpty == true)
                              Text(
                                currentProduct?.category?.name?.isNotEmpty == true ? '   ${currentProduct!.brand!.name!.capitalize()}' : currentProduct!.brand!.name!.capitalize(),
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                          ],
                        ),
                      SizedBox(
                        height: responsiveData.scaleHeight(20),
                      ),
                      Row(
                        children: [
                          AppNaira(
                            fontSize: Responsive.fontSize(context, 28).toInt(),
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          Text(
                            NumberFormat('#,###').format(
                                double.tryParse(currentProduct?.price?.toString() ?? '0') ?? 0
                            ),
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(12),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            Assets.svg.star,
                            width: responsiveData.scaleWidth(20), // Added for consistency
                            height: responsiveData.scaleHeight(20),
                          ),
                          SizedBox(
                            width: responsiveData.scaleWidth(10),
                          ),
                          Text(
                            '${currentProduct?.quantitySold} units sold',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          SizedBox(
                            width: responsiveData.scaleWidth(10),
                          ),
                          AppDot(
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: responsiveData.scaleWidth(10),
                          ),
                          Text(
                            '${currentProduct?.quantityAvailable} units left',
                            style: Theme.of(context).textTheme.displaySmall,
                          )
                        ],
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(32),
                      ),
                      GestureDetector(
                        onTap: () {
                          locator<PayvidenceAppRouter>().navigate(
                              UpdateQuantityRoute(product: currentProduct!));
                        },
                        child: Text(
                          'Update quantity',
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                              color: primaryColor2, decoration: TextDecoration.underline),
                        ),
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(73),
                      ),
                      AppButton(
                        buttonText: 'Record sale',
                        onPressed: () {
                          locator<PayvidenceAppRouter>().navigate(
                            GenerateReceiptRoute(isInvoice: false),
                          );
                        },
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(8),
                      ),
                      AppButton(
                        buttonText: 'Generate invoice',
                        onPressed: () {
                          locator<PayvidenceAppRouter>().navigate(
                            GenerateReceiptRoute(isInvoice: true),
                          );
                        },
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
      ),
    );
  }

  Future<dynamic> _buildConfirmDeleteBottomSheet(
      BuildContext context, void Function() onDelete) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final responsiveData = ResponsiveInherited.of(context);

    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) {
        return Container(
          height: responsiveData.scaleHeight(398),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(responsiveData.smallRadius * 2), // Approx 40.r equivalent
              topLeft: Radius.circular(responsiveData.smallRadius * 2), // Approx 40.r equivalent
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: responsiveData.paddingHorizontal, vertical: responsiveData.scaleHeight(10)),
            child: Stack(
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(140)),
                      child: Container(
                        height: responsiveData.scaleHeight(5),
                        width: responsiveData.scaleWidth(67),
                        decoration: BoxDecoration(
                          color: const Color(0xffd9d9d9),
                          borderRadius: BorderRadius.circular(responsiveData.smallRadius * 5), // Approx 100.r equivalent
                        ),
                      ),
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(38),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Center(
                          child: Text(
                            'Confirm delete',
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                              fontSize: Responsive.fontSize(context, 22),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(Icons.close),
                        )
                      ],
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(12),
                    ),
                    Center(
                      child: Text(
                        'Are you sure you want to delete this product?\n\nAll details and statistics will be gone.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(47),
                    ),
                    AppButton(
                      buttonText: 'Delete product',
                      onPressed: onDelete,
                      backgroundColor: appRed,
                      textColor: Colors.white,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
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
      },
    );
  }
}