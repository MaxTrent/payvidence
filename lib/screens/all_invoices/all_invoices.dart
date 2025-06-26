import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/components/app_text_field.dart';
import 'package:payvidence/components/custom_shimmer.dart';
import 'package:payvidence/components/pull_to_refresh.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/gen/assets.gen.dart';
import 'package:payvidence/providers/receipt_providers/get_all_invoice_provider.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import 'package:payvidence/utilities/theme_mode.dart';
import '../all_receipts/all_receipts.dart';

@RoutePage(name: 'AllInvoicesRoute')
class AllInvoices extends HookConsumerWidget {
  const AllInvoices({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allInvoices = ref.watch(getAllInvoiceProvider);
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
      await ref.refresh(getAllInvoiceProvider.future);
    }

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: false,
          title: ValueListenableBuilder(
            builder: (context, value, _) {
              return Text(
                'All invoices (${value ?? '0'})',
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
                    locator<PayvidenceAppRouter>().push(DraftsRoute(isInvoice: true));
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
              AppTextField(
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
                hintText: 'Search for invoice',
                controller: searchController,
                radius: responsiveData.largeRadius,
                filled: true,
                fillColor: isDarkMode ? Colors.black : appGrey5,
              ),
              SizedBox(height: responsiveData.scaleHeight(20)),
              Expanded(
                child: allInvoices.when(
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
                                SizedBox(height: responsiveData.scaleHeight(80),),
                                SvgPicture.asset(Assets.svg.emptyInvoice),
                                SizedBox(height: responsiveData.scaleHeight(40)),
                                Text(
                                  searchQuery.value.isEmpty ? 'No invoice yet!' : 'No invoices found!',
                                  style: Theme.of(context).textTheme.displayLarge,
                                ),
                                SizedBox(height: responsiveData.scaleHeight(10)),
                                Text(
                                  searchQuery.value.isEmpty
                                      ? 'Generate invoice for your business pending sales. All invoices generated will show here.'
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
                                    padding: EdgeInsets.only(bottom: responsiveData.scaleHeight(44)),
                                    child: AppButton(
                                      buttonText: 'Generate invoice',
                                      onPressed: () {
                                        locator<PayvidenceAppRouter>()
                                            .navigate(GenerateReceiptRoute(isInvoice: true));
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
                          return GestureDetector(
                            onTap: () {
                              locator<PayvidenceAppRouter>().navigate(
                                ReceiptScreenRoute(
                                  record: filteredData[index],
                                  isInvoice: true,
                                ),
                              );
                            },
                            child: ReceiptTile(receipt: filteredData[index]),
                          );
                        },
                        physics: const NeverScrollableScrollPhysics(),
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
        floatingActionButton: allInvoices.when(
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
                locator<PayvidenceAppRouter>().navigate(GenerateReceiptRoute(isInvoice: true));
              },
              backgroundColor: primaryColor2,
              child: Icon(Icons.add, size: responsiveData.scaleHeight(40)),
            )
                : null; // Hide FAB when there are no invoices
          },
          error: (error, _) => null, // Hide FAB on error
          loading: () => null, // Hide FAB while loading
        ),
      ),
    );
  }
}