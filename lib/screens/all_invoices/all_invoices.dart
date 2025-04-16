import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../components/pull_to_refresh.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../providers/receipt_providers/get_all_invoice_provider.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/theme_mode.dart';
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

    return Scaffold(
      appBar: AppBar(
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
              padding: EdgeInsets.only(right: 20.w),
              child: GestureDetector(
                onTap: () {
                  locator<PayvidenceAppRouter>().push(DraftsRoute(isInvoice: true));
                },
                child: Text(
                  'View drafts',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: 14.sp, color: primaryColor2),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 32.h),
            AppTextField(
              prefixIcon: Padding(
                padding: EdgeInsets.all(16.h),
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
              radius: 80,
              filled: true,
              fillColor: isDarkMode ? Colors.black : appGrey5,
            ),
            SizedBox(height: 20.h),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(Assets.svg.emptyInvoice),
                          SizedBox(height: 40.h),
                          Text(
                            searchQuery.value.isEmpty ? 'No invoice yet!' : 'No invoices found!',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            searchQuery.value.isEmpty
                                ? 'Generate invoice for your business pending sales. All invoices generated will show here.'
                                : 'Try a different search term.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 14.sp),
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
                        children: [SizedBox(height: 24.h)],
                      ),
                      itemCount: filteredData.length,
                    ),
                  );
                },
                error: (error, _) => PullToRefresh(
                  onRefresh: onRefresh,
                  child: const Center(child: Text('An error has occurred')),
                ),
                loading: () => ListView.builder(
                  itemCount: 5,
                  itemBuilder: (_, index) => CustomShimmer(height: 60.h),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          locator<PayvidenceAppRouter>().navigate(GenerateReceiptRoute(isInvoice: true));
        },
        backgroundColor: primaryColor2,
        child: Icon(Icons.add, size: 40.h),
      ),
    );
  }
}
