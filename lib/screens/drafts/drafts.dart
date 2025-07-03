import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:payvidence/providers/receipt_providers/get_all_invoice_provider.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import '../../components/app_naira.dart';
import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../components/loading_dialog.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../model/receipt_model.dart';
import '../../providers/receipt_providers/get_all_receipt_provider.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/theme_mode.dart';
import '../../utilities/toast_service.dart';

@RoutePage(name: 'DraftsRoute')
class Drafts extends HookConsumerWidget {
  final bool? isInvoice;

  Drafts({super.key, this.isInvoice = false});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final responsiveData = ResponsiveInherited.of(context);

    final allReceipts = isInvoice == true
        ? ref.watch(getAllInvoiceProvider)
        : ref.watch(getAllReceiptProvider);

    Future<void> deleteProduct(String id) async {
      if (!context.mounted) return;
      LoadingDialog.show(context);
      try {
        final response =
        await ref.read(getAllReceiptProvider.notifier).deleteDraft(id);
        if (!context.mounted) return;
        Navigator.of(context).pop(); //pop loading dialog on success
        ToastService.showSnackBar("Draft deleted successfully");
        ref.invalidate(
            isInvoice == true ? getAllInvoiceProvider : getAllReceiptProvider);
        Future.delayed(const Duration(seconds: 2), () {});
      } on DioException catch (e) {
        Navigator.of(context).pop(); // pop loading dialog on error
        ToastService.showErrorSnackBar(
            e.response?.data['message'] ?? 'An unknown error has occurred!!!');
      } catch (e) {
        print(e);
        Navigator.of(context).pop(); // pop loading dialog on error
        ToastService.showErrorSnackBar('An unknown error has occurred!');
      }
    }

    ValueNotifier<int?> productNumber = ValueNotifier(null);
    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: false,
          title: ValueListenableBuilder(
            builder: (context, value, _) {
              return Text(
                'Drafts (${value ?? '0'})',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(),
              );
            },
            valueListenable: productNumber,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: responsiveData.scaleHeight(32),
                ),
                AppTextField(
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(responsiveData.scaleHeight(16)),
                    child: SvgPicture.asset(
                      Assets.svg.search,
                      colorFilter: ColorFilter.mode(
                          isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn),
                      width: responsiveData.scaleWidth(24),
                      height: responsiveData.scaleHeight(24),
                    ),
                  ),
                  hintText: 'Search for product',
                  controller: _searchController,
                  radius: responsiveData.largeRadius,
                  filled: isDarkMode ? false : true,
                  appBorderColor: isDarkMode ? Colors.white : Colors.transparent,
                  fillColor: isDarkMode ? Colors.black : appGrey5,
                ),
                SizedBox(
                  height: responsiveData.scaleHeight(20),
                ),
                allReceipts.when(data: (data) {
                  final actualData =
                  data.where((data) => data.publishedAt == null).toList();

                  if (actualData.isEmpty) {
                    productNumber.value = 0;

                    return SizedBox(
                      width: responsiveData.screenWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: responsiveData.screenHeight / 4,
                          ),
                          Text(
                            'No receipts in drafts!',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          SizedBox(
                            height: responsiveData.scaleHeight(10),
                          ),
                          Text(
                            'All receipts in drafts will appear here.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                              fontSize: Responsive.fontSize(context, 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  productNumber.value = actualData.length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You can click on specific draft to edit.',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(8),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return DraftTile(
                            draft: actualData[index],
                            onPressed: (String id) {
                              deleteProduct(id);
                            },
                            isInvoice: isInvoice ?? false,
                          );
                        },
                        separatorBuilder: (ctx, idx) {
                          return Column(
                            children: [
                              SizedBox(
                                height: responsiveData.scaleHeight(24),
                              ),
                            ],
                          );
                        },
                        itemCount: actualData.length,
                      ),
                      SizedBox(
                        height: responsiveData.scaleHeight(40),
                      ),
                    ],
                  );
                }, error: (error, _) {
                  return const Text('An error has occurred');
                }, loading: () {
                  return const CustomShimmer();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DraftTile extends StatelessWidget {
  final void Function(String id) onPressed;
  final Receipt draft;
  final bool isInvoice;

  const DraftTile({
    super.key,
    required this.draft,
    required this.onPressed,
    required this.isInvoice,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        locator<PayvidenceAppRouter>()
            .navigate(CompleteDraftRoute(draft: draft, isInvoice: isInvoice));
      },
      child: Container(
        height: responsiveData.scaleHeight(101),
        width: responsiveData.screenWidth,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: responsiveData.scaleHeight(72),
              width: responsiveData.scaleHeight(72),
              decoration: const BoxDecoration(color: Colors.black),
            ),
            SizedBox(
              width: responsiveData.scaleWidth(14),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    draft.recordProductDetails[0].product?.name ?? '',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(6),
                  ),
                  Row(
                    children: [
                      Text(
                        '${draft.recordProductDetails[0].quantity ?? ''} units sold',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                          fontSize: Responsive.fontSize(context, 14),
                          color: appGrey4,
                        ),
                      ),
                      SizedBox(
                        width: responsiveData.scaleWidth(10),
                      ),
                      Container(
                        height: responsiveData.scaleHeight(6),
                        width: responsiveData.scaleHeight(6),
                        decoration: BoxDecoration(
                          color: appGrey4,
                          borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                        ),
                      ),
                      SizedBox(
                        width: responsiveData.scaleWidth(10),
                      ),
                      Expanded(
                        child: Text(
                          DateFormat.yMd().add_jm().format(draft.createdAt!),
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                            fontSize: Responsive.fontSize(context, 14),
                            color: appGrey4,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: responsiveData.scaleWidth(10),
                      ),
                      GestureDetector(
                        onTap: () {
                          onPressed.call(draft.id ?? '');
                        },
                        child: SvgPicture.asset(
                          Assets.svg.delete,
                          width: responsiveData.scaleWidth(24),
                          height: responsiveData.scaleHeight(24),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: responsiveData.scaleHeight(8),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppNaira(fontSize: 14, color: isDarkMode ? Colors.white : Colors.black),
                      Text(
                        '${draft.recordProductDetails[0].total ?? ''} ',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                          fontSize: Responsive.fontSize(context, 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}