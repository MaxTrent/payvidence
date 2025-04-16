import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/providers/receipt_providers/get_all_receipt_provider.dart';
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

    return Scaffold(
      appBar: AppBar(
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
              padding: EdgeInsets.only(right: 20.w),
              child: GestureDetector(
                onTap: () {
                  locator<PayvidenceAppRouter>().navigate(DraftsRoute(isInvoice: false));
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
              hintText: 'Search for receipt',
              controller: searchController,
              radius: 80,
              filled: true,
              fillColor: isDarkMode ? Colors.black : appGrey5,
            ),
            SizedBox(height: 20.h),
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
                          height: ScreenUtil().screenHeight - 200.h, // Adjust for app bar and padding
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                searchQuery.value.isEmpty
                                    ? 'No receipts available!'
                                    : 'No receipts found!',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                searchQuery.value.isEmpty
                                    ? 'All added receipts will appear here.'
                                    : 'Try a different search term.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(fontSize: 14.sp),
                              ),
                              if (searchQuery.value.isEmpty) ...[
                                SizedBox(height: 48.h),
                                AppButton(
                                  buttonText: 'Generate receipt',
                                  onPressed: () {
                                    locator<PayvidenceAppRouter>()
                                        .navigate(GenerateReceiptRoute(isInvoice: false));
                                  },
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
                                isInvoice: false,
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
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: ScreenUtil().screenHeight - 200.h,
                      child: const Center(child: Text('An error has occurred')),
                    ),
                  ),
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
          locator<PayvidenceAppRouter>().navigate(GenerateReceiptRoute(isInvoice: false));
        },
        backgroundColor: primaryColor2,
        child: Icon(Icons.add, size: 40.h),
      ),
    );
  }
}

class ReceiptTile extends StatelessWidget {
  final Receipt receipt;

  const ReceiptTile({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 72.h,
          width: 72.h,
          decoration: const BoxDecoration(color: Colors.black),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                receipt.recordProductDetails?[0].product?.name ?? '',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(height: 6.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${receipt.recordProductDetails?[0].quantity ?? ''} units sold',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontSize: 14.sp, color: appGrey4),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    height: 6.h,
                    width: 6.h,
                    decoration: BoxDecoration(
                      color: appGrey4,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      DateFormat.yMd().add_jm().format(receipt.createdAt!),
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: 14.sp, color: appGrey4),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  const AppNaira(fontSize: 14),
                  Text(
                    '${receipt.recordProductDetails?[0].total ?? ''} ',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 14.sp),
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