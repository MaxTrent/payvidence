import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/providers/receipt_providers/get_all_receipt_provider.dart';
import 'package:payvidence/utilities/animations.dart';
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
      child: Scaffold(
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
                  hintText: 'Search for receipt',
                  controller: searchController,
                  radius: responsiveData.largeRadius,
                  filled: true,
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
                    receipt.recordProductDetails?[0].product?.name
                        ?.toLowerCase()
                        .contains(searchQuery.value.toLowerCase()) ??
                        false)
                        .toList();

                    if (filteredData.isEmpty) {
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
                                SizedBox(height: responsiveData.scaleHeight(80)),
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
                                    padding: EdgeInsets.only(bottom: responsiveData.scaleHeight(14)),
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
                              child: ReceiptTile(receipt: filteredData[index]),
                            ),
                          );
                        },
                        // physics: const AlwaysScrollableScrollPhysics(),
                        separatorBuilder: (ctx, idx) => Column(
                          children: [SizedBox(height: responsiveData.scaleHeight(24))],
                        ),
                        itemCount: filteredData.length,
                      ),
                    );
                  },
                  error: (error, _) => PullToRefresh(
                    onRefresh: onRefresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - responsiveData.scaleHeight(200),
                        child: const Center(child: Text('An error has occurred')),
                      ),
                    ),
                  ),
                  loading: () => ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (ctx, idx) => SizedBox(height: responsiveData.scaleHeight(12)),
                    itemCount: 5,
                    itemBuilder: (_, index) => CustomShimmer(height: responsiveData.scaleHeight(60)),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: allReceipts.when(
          data: (data) {
            final actualData = data.where((data) => data.publishedAt != null).toList();
            final filteredData = searchQuery.value.isEmpty
                ? actualData
                : actualData
                .where((receipt) =>
            receipt.recordProductDetails?[0].product?.name
                ?.toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ??
                false)
                .toList();
            return filteredData.isNotEmpty
                ? FloatingActionButton(
              onPressed: () {
                locator<PayvidenceAppRouter>().navigate(GenerateReceiptRoute(isInvoice: false));
              },
              backgroundColor: primaryColor2,
              child: Icon(Icons.add, size: responsiveData.scaleHeight(40), color: Colors.white,),
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

class ReceiptTile extends StatelessWidget {
  final Receipt receipt;

  const ReceiptTile({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: responsiveData.scaleHeight(72),
          width: responsiveData.scaleHeight(72),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: (receipt.recordProductDetails[0].product?.logoUrl != null && 
                 receipt.recordProductDetails[0].product!.logoUrl!.isNotEmpty)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    receipt.recordProductDetails[0].product!.logoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          Assets.png.payvidenceLogo.path,
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    Assets.png.payvidenceLogo.path,
                    fit: BoxFit.contain,
                  ),
                ),
        ),
        SizedBox(width: responsiveData.scaleWidth(14)),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                receipt.recordProductDetails[0].product?.name ?? '',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(height: responsiveData.scaleHeight(6)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${receipt.recordProductDetails[0].quantity ?? ''} units sold',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontSize: Responsive.fontSize(context, 14), color: appGrey4),
                  ),
                  SizedBox(width: responsiveData.scaleWidth(10)),
                  Container(
                    height: responsiveData.scaleHeight(6),
                    width: responsiveData.scaleHeight(6),
                    decoration: BoxDecoration(
                      color: appGrey4,
                      borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                    ),
                  ),
                  SizedBox(width: responsiveData.scaleWidth(10)),
                  Expanded(
                    child: Text(
                      DateFormat.yMd().add_jm().format(receipt.createdAt!),
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: Responsive.fontSize(context, 14), color: appGrey4),
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsiveData.scaleHeight(8)),
              Row(
                children: [
                  const AppNaira(fontSize: 14),
                  Text(
                    '${receipt.recordProductDetails[0].total ?? ''} ',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: Responsive.fontSize(context, 14)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}