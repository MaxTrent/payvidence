import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/providers/receipt_providers/get_all_receipt_provider.dart';
import 'package:payvidence/utilities/animations.dart';
import 'package:payvidence/utilities/extensions.dart';
import '../../components/app_button.dart';
import '../../components/app_naira.dart';
import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../components/pull_to_refresh.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/responsive.dart';
import '../../utilities/responsive_wrapper.dart';
import '../../utilities/theme_mode.dart';

@RoutePage(name: 'AllReceiptsRoute')
class AllReceipts extends HookConsumerWidget {
  const AllReceipts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allReceipts = ref.watch(getAllReceiptProvider);
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final searchController = useTextEditingController();
    final searchQuery = useState<String>('');
    final productNumber = ValueNotifier<int?>(null);
    final responsiveData = ResponsiveInherited.of(context);

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
      await ref.refresh(getAllReceiptProvider.future);
    }

    return ResponsiveWrapper(
      child: KeyboardDismissibleScaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: false,
          title: ValueListenableBuilder(
            builder: (context, value, _) {
              return Text(
                'All receipts (${value ?? '0'})',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(),
              );
            },
            valueListenable: productNumber,
          ),
          actions: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(right: responsiveData.scaleWidth(20)),
                child: GestureDetector(
                  onTap: () {
                    locator<PayvidenceAppRouter>().navigate(DraftsRoute(isInvoice: false));
                  },
                  child: Text(
                    'View drafts',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: Responsive.fontSize(context, 14), color: primaryColor2),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: responsiveData.scaleHeight(32)),
              FadeInWidget(
                delay: const Duration(milliseconds: 100),
                child: AppTextField(
                  appBorderColor: isDarkMode ? Colors.white: Colors.transparent,
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
                  filled: isDarkMode ? false : true,
                  fillColor: isDarkMode ? Colors.black : appGrey5,
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(20)),
              Expanded(
                child: allReceipts.when(
                  data: (data) {
                    final actualData = data.where((data) => data.publishedAt != null).toList();
                    final filteredData = searchQuery.value.isEmpty
                        ? actualData
                        : actualData
                        .where((receipt) =>
                    receipt.recordProductDetails[0].product?.name
                        ?.toLowerCase()
                        .contains(searchQuery.value.toLowerCase()) ??
                        false)
                        .toList();

                    if (filteredData.isEmpty) {
                      productNumber.value = 0;
                      return PullToRefresh(
                        onRefresh: onRefresh,
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Column(
                                children: [
                                  const Spacer(),
                                  SvgPicture.asset(Assets.svg.emptyReceipt, height: responsiveData.scaleHeight(200),width: responsiveData.scaleWidth(200),),
                                  SizedBox(height: responsiveData.scaleHeight(40)),
                                  Text(
                                    searchQuery.value.isEmpty
                                        ? 'No receipts yet!'
                                        : 'No receipts found!',
                                    style: Theme.of(context).textTheme.displayLarge,
                                  ),
                                  SizedBox(height: responsiveData.scaleHeight(10)),
                                  Text(
                                    searchQuery.value.isEmpty
                                        ? 'Generate receipts for your business sales. All receipts generated will show here.'
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
                                      padding: EdgeInsets.all(responsiveData.scaleHeight(20)),
                                      child: AppButton(
                                        buttonText: 'Generate receipt',
                                        onPressed: () {
                                          locator<PayvidenceAppRouter>()
                                              .navigate(GenerateReceiptRoute(isInvoice: false));
                                        },
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    productNumber.value = filteredData.length;
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
                                locator<PayvidenceAppRouter>().navigate(
                                  ReceiptScreenRoute(
                                    record: filteredData[index],
                                    isInvoice: false,
                                  ),
                                );
                              },
                              child: ReceiptTile(
                                receipt: filteredData[index],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (ctx, idx) {
                          return SizedBox(
                            height: responsiveData.scaleHeight(24),
                          );
                        },
                        itemCount: filteredData.length,
                      ),
                    );
                  },
                  error: (error, _) {
                    return const Text('An error has occurred');
                  },
                  loading: () {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: 5,
                      separatorBuilder: (ctx, idx) => SizedBox(height: responsiveData.scaleHeight(24)),
                      itemBuilder: (_, index) => Container(
                        height: responsiveData.scaleHeight(101),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: responsiveData.scaleHeight(69),
                              width: responsiveData.scaleWidth(69),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                              ),
                              child: CustomShimmer(
                                height: responsiveData.scaleHeight(69),
                                width: responsiveData.scaleWidth(69),
                              ),
                            ),
                            SizedBox(width: responsiveData.scaleWidth(12)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomShimmer(
                                        height: responsiveData.scaleHeight(16),
                                        width: responsiveData.scaleWidth(120),
                                      ),
                                      CustomShimmer(
                                        height: responsiveData.scaleHeight(16),
                                        width: responsiveData.scaleWidth(80),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomShimmer(
                                        height: responsiveData.scaleHeight(12),
                                        width: responsiveData.scaleWidth(100),
                                      ),
                                      CustomShimmer(
                                        height: responsiveData.scaleHeight(12),
                                        width: responsiveData.scaleWidth(60),
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReceiptTile extends StatelessWidget {
  const ReceiptTile({
    required this.receipt,
    super.key,
  });

  final Receipt receipt;

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);

    final firstProductDetail = receipt.recordProductDetails?.isNotEmpty == true
        ? receipt.recordProductDetails!.first
        : null;

    final product = firstProductDetail?.product;
    final productName = product?.name ?? 'Unknown Product';
    final amount = product != null
        ? (double.tryParse(product.price ?? '0') ?? 0)
        .toString()
        .toCommaSeparated()
        : '0';
    final imageUrl = product?.logoUrl ?? "";
    final dateTime = receipt.createdAt?.toString().toFormattedIsoDate() ?? '';
    final unitSold = product?.quantitySold?.toString() ?? '0';

    return Container(
      height: responsiveData.scaleHeight(101),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(responsiveData.smallRadius),
        border: Border.all(
          color: borderColor,
          width: responsiveData.scaleWidth(1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(responsiveData.scaleHeight(16)),
        child: Row(
          children: [
            Container(
              height: responsiveData.scaleHeight(69),
              width: responsiveData.scaleWidth(69),
              decoration: BoxDecoration(
                color: appGrey5,
                borderRadius: BorderRadius.circular(responsiveData.smallRadius),
              ),
              child: imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: responsiveData.scaleHeight(30),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    )
                  : Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: responsiveData.scaleHeight(30),
                    ),
            ),
            SizedBox(width: responsiveData.scaleWidth(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          productName,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontSize: Responsive.fontSize(context, 16)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          AppNaira(
                            fontSize: 16,
                          ),
                          Text(
                            amount,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontSize: Responsive.fontSize(context, 16)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateTime,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: Responsive.fontSize(context, 12)),
                      ),
                      Text(
                        '$unitSold unit${int.tryParse(unitSold) != 1 ? 's' : ''} sold',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: Responsive.fontSize(context, 12)),
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