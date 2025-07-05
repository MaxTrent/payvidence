import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/components/app_text_field.dart';
import 'package:payvidence/components/custom_shimmer.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
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
import 'package:payvidence/utilities/animations.dart';
import 'package:payvidence/utilities/toast_service.dart';
import '../../components/simple_bottom_sheet.dart';
import '../../providers/product_providers/current_product_provider.dart';
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
      child: KeyboardDismissibleScaffold(
        resizeToAvoidBottomInset: false,
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
              FadeInWidget(
                delay: const Duration(milliseconds: 100),
                child: AppTextField(
                  appBorderColor: isDarkMode ? Colors.white : Colors.transparent,
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
                  filled: isDarkMode ? false : true,
                  fillColor: isDarkMode ? Colors.black : appGrey5,
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(20)),
              Expanded(
                child: allInvoices.when(
                  data: (data) {
                    final actualData = data.where((data) => data.publishedAt != null).toList()
                      ..sort((a, b) => (b.createdAt ?? DateTime(1970)).compareTo(a.createdAt ?? DateTime(1970)));
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
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverFillRemaining(
                              hasScrollBody: false,
                              child: Column(
                                children: [
                                  const Spacer(),
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
                                      padding: EdgeInsets.all(responsiveData.scaleHeight(20)),
                                      child: AppButton(
                                        buttonText: 'Generate invoice',
                                        onPressed: () {
                                          ref.read(getCurrentProductProvider.notifier).state = null;
                                          locator<PayvidenceAppRouter>()
                                              .navigate(GenerateReceiptRoute(isInvoice: true));
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
                            child: Dismissible(
                              key: Key(filteredData[index].id ?? index.toString()),
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
                                    title: 'Delete Invoice',
                                    subtitle: 'Are you sure you want to delete this invoice?',
                                    height: responsiveData.scaleHeight(500),
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.of(context).pop(true),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color: appRed,
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
                                if (result == true) {
                                  try {
                                    await ref.read(getAllInvoiceProvider.notifier).deleteDraft(filteredData[index].id!);
                                    return true;
                                  } catch (e) {
                                    String errorMessage = 'Failed to delete invoice';
                                    if (e.toString().contains('forbidden') || e.toString().contains('cannot delete published record')) {
                                      errorMessage = 'Cannot delete published invoice';
                                    }
                                    ToastService.showErrorSnackBar(errorMessage);
                                    return false;
                                  }
                                }
                                return false;
                              },
                              onDismissed: (direction) {
                                ref.invalidate(getAllInvoiceProvider);
                              },
                              child: GestureDetector(
                                onTap: () {
                                  locator<PayvidenceAppRouter>().navigate(
                                    ReceiptScreenRoute(
                                      record: filteredData[index],
                                      isInvoice: true,
                                    ),
                                  );
                                },
                                child: ReceiptTile(receipt: filteredData[index]),
                              ),
                            ),
                          );
                        },
                        physics: const AlwaysScrollableScrollPhysics(),
                        separatorBuilder: (ctx, idx) => Column(
                          children: [SizedBox(height: responsiveData.scaleHeight(12))],
                        ),
                        itemCount: filteredData.length,
                      ),
                    );
                  },
                  error: (error, _) {
                    return PullToRefresh(
                      onRefresh: onRefresh,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            error.toString().contains('timeout')
                                ? 'Connection is slow. Please check your internet and try again.'
                                : 'Unable to load invoices. Please try again.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          SizedBox(height: responsiveData.scaleHeight(16)),
                          AppButton(
                            buttonText: 'Retry',
                            onPressed: () async {
                              await onRefresh();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  loading: () {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: 5,
                      separatorBuilder: (ctx, idx) => SizedBox(height: responsiveData.scaleHeight(12)),
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
        floatingActionButton: allInvoices.when(
          data: (data) {
            final actualData = data.where((data) => data.publishedAt != null).toList()
              ..sort((a, b) => (b.createdAt ?? DateTime(1970)).compareTo(a.createdAt ?? DateTime(1970)));
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
                ref.read(getCurrentProductProvider.notifier).state = null;
                locator<PayvidenceAppRouter>().navigate(GenerateReceiptRoute(isInvoice: true));
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