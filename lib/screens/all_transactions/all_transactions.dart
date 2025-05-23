import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/pull_to_refresh.dart';
import 'package:payvidence/data/local/session_constants.dart';
import 'package:payvidence/data/local/session_manager.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/screens/all_transactions/all_transactions_vm.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/extensions.dart';
import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../components/transaction_tile.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../model/business_model.dart';
import '../../model/client_model.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../utilities/theme_mode.dart';

@RoutePage(name: 'AllTransactionsRoute')
class AllTransactions extends HookConsumerWidget {
  const AllTransactions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(allTransactionsViewModelProvider);
    final searchController = useTextEditingController();
    final businessId =
    locator<SessionManager>().get<String>(SessionConstants.businessId);
    final filterType = useState('All');
    final searchQuery = useState('');
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;

    useEffect(() {
      Future.microtask(() {
        viewModel.fetchTransactions(businessId!);
      });

      void listener() {
        searchQuery.value = searchController.text;
      }

      searchController.addListener(listener);
      return () {
        searchController.removeListener(listener);
      };
    }, [businessId, searchController]);

    final filteredTransactions = viewModel.transactions.where((transaction) {
      final isReceipt =
          transaction.status != 'pending'; // Assuming 'pending' means Invoice
      final isInvoice = transaction.status == 'pending';
      final matchesFilter = filterType.value == 'All' ||
          (filterType.value == 'Receipt' && isReceipt) ||
          (filterType.value == 'Invoice' && isInvoice);

      final firstProductDetail = transaction.recordProductDetails.isNotEmpty
          ? transaction.recordProductDetails.first
          : null;
      final productName = firstProductDetail?.product?.name ?? '';
      final matchesSearch = searchQuery.value.isEmpty ||
          productName.toLowerCase().contains(searchQuery.value.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();

    Future<void> onRefresh() async {
      if (businessId != null) {
        await viewModel.fetchTransactions(businessId);
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'All transactions (${filteredTransactions.length})',
          style: Theme.of(context).textTheme.displayLarge!,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: PullToRefresh(
          onRefresh: onRefresh,
          child: ListView(
            children: [
              SizedBox(height: 32.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextField(
                    width: 282.w,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(16.h),
                      child: SvgPicture.asset(Assets.svg.search),
                    ),
                    hintText: 'Search for transaction',
                    controller: searchController,
                    radius: 80,
                    filled: true,
                    fillColor: appGrey5,
                  ),
                  GestureDetector(
                    onTap: () {
                      buildFilterBottomSheet(context, filterType, isDarkMode);
                    },
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: borderColor,
                        borderRadius: BorderRadius.circular(56.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(14.h),
                        child: SvgPicture.asset(Assets.svg.filter),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              if (viewModel.isLoading) ...[
                CustomShimmer(height: 101.h),
                SizedBox(height: 24.h),
                CustomShimmer(height: 101.h),
                SizedBox(height: 24.h),
                CustomShimmer(height: 101.h),
                SizedBox(height: 24.h),
                CustomShimmer(height: 101.h),
              ] else if (filteredTransactions.isEmpty) ...[
                SizedBox(height: 20.h),
                SvgPicture.asset(Assets.svg.emptyTransaction),
                SizedBox(height: 40.h),
                Text(
                  filterType.value != 'All' && viewModel.transactions.isNotEmpty
                      ? 'No ${filterType.value}s found!'
                      : 'No transaction yet!',
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                Text(
                  filterType.value != 'All' && viewModel.transactions.isNotEmpty
                      ? 'Try adjusting your filter or search.'
                      : 'Start generating receipts and invoices for your business. All transactions will show here.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontSize: 14.sp),
                ),
              ] else ...[
                ...filteredTransactions.map(
                      (transaction) {
                    final firstProductDetail =
                        transaction.recordProductDetails.first;
                    final isInvoice = transaction.status == 'pending';

                    // Handle null product case
                    final product = firstProductDetail.product;
                    final productName = product?.name ?? 'Unknown Product';
                    final amount = product != null
                        ? (double.tryParse(product.price ?? '0') ?? 0)
                        .toString()
                        .toCommaSeparated()
                        : '0';
                    final dateTime = product?.createdAt
                        ?.toString()
                        .toFormattedIsoDate() ??
                        '';
                    final unitSold = product?.quantitySold?.toString() ?? '0';

                    return GestureDetector(
                      onTap: () {
                        final receipt = Receipt(
                          id: transaction.id,
                          business: Business(
                            id: transaction.business.id,
                            accountId: transaction.business.accountId,
                            name: transaction.business.name,
                            address: transaction.business.address,
                            phoneNumber: transaction.business.phoneNumber,
                            logoUrl: transaction.business.logoUrl,
                            issuer: transaction.business.issuer,
                            issuerRole: transaction.business.issuerRole,
                            issuerSignatureUrl:
                            transaction.business.issuerSignatureUrl,
                            bankName: transaction.business.bankName,
                            accountNumber: transaction.business.accountNumber,
                            accountName: transaction.business.accountName,
                            createdAt: transaction.business.createdAt,
                            updatedAt: transaction.business.updatedAt,
                          ),
                          client: ClientModel(
                            id: transaction.client.id,
                            businessId: transaction.client.businessId,
                            name: transaction.client.name,
                            phoneNumber: transaction.client.phoneNumber,
                            address: transaction.client.address,
                            createdAt: transaction.client.createdAt,
                            updatedAt: transaction.client.updatedAt,
                          ),
                          recordProductDetails: transaction.recordProductDetails,
                          total: transaction.total.toString(),
                          createdAt: transaction.createdAt,
                          modeOfPayment: transaction.modeOfPayment,
                        );
                        locator<PayvidenceAppRouter>().push(
                          ReceiptScreenRoute(record: receipt, isInvoice: isInvoice),
                        );
                      },
                      child: TransactionTile(
                        amount: amount,
                        dateTime: dateTime,
                        productName: productName,
                        receiptOrInvoice: transaction.status == 'pending'
                            ? 'Invoice'
                            : 'Receipt',
                        unitSold: unitSold,
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> buildFilterBottomSheet(
      BuildContext context, ValueNotifier<String?> filterType, bool isDarkMode) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) {
        return Container(
          height: 326.h,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40.r),
              topLeft: Radius.circular(40.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Stack(
              children: [
                ListView(
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
                    SizedBox(height: 38.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Center(
                          child: Text(
                            'Filter transactions',
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
                          child: Icon(
                            Icons.close,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Center(
                      child: Text(
                        'Select transaction type you’ll like to see.',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    GestureDetector(
                      onTap: () {
                        filterType.value = 'Receipt';
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              Assets.svg.receipt,
                              colorFilter: ColorFilter.mode(
                                  isDarkMode ? Colors.white : Colors.black,
                                  BlendMode.srcIn),
                            ),
                            SizedBox(width: 16.w),
                            Text(
                              'Receipt',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 1.h),
                    GestureDetector(
                      onTap: () {
                        filterType.value = 'Invoice';
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                                Assets.svg.invoice,
                                colorFilter: ColorFilter.mode(
                                    isDarkMode ? Colors.white : Colors.black,
                                    BlendMode.srcIn)),
                            SizedBox(width: 16.w),
                            Text(
                              'Invoice',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: 1.h),
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