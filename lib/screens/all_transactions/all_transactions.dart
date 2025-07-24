import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/pull_to_refresh.dart';
import 'package:payvidence/data/local/session_constants.dart';
import 'package:payvidence/data/local/session_manager.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/screens/all_transactions/all_transactions_vm.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/extensions.dart';
import 'package:payvidence/utilities/animations.dart';
import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../components/keyboard_dismissible_scaffold.dart';
import '../../components/transaction_tile.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../model/business_model.dart';
import '../../model/client_model.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../utilities/responsive.dart';
import '../../utilities/responsive_wrapper.dart';
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
    final isServiceMode = useState<bool?>(null); // null represents 'All'
    final searchQuery = useState('');
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final responsiveData = ResponsiveInherited.of(context);

    useEffect(() {
      Future.microtask(() {
        if (businessId != null) {
          viewModel.fetchTransactions(businessId);
        }
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
      final isReceipt = transaction.status != 'pending';
      final isInvoice = transaction.status == 'pending';
      final matchesFilter = filterType.value == 'All' ||
          (filterType.value == 'Receipt' && isReceipt) ||
          (filterType.value == 'Invoice' && isInvoice);
      
      // Filter by service/product type if not 'All'
      if (isServiceMode.value != null && transaction.recordProductDetails.isNotEmpty) {
        bool isService = transaction.recordProductDetails.any((detail) => 
          detail.isService ?? false);
        
        if (isServiceMode.value != isService) {
          return false;
        }
      }

      // Search in client name if product details are missing
      if (searchQuery.value.isEmpty) {
        return matchesFilter;
      }
      
      final query = searchQuery.value.toLowerCase();
      
      // Check product/service name if available
      if (transaction.recordProductDetails.isNotEmpty) {
        final firstProductDetail = transaction.recordProductDetails.first;
        final productName = firstProductDetail.product?.name?.toLowerCase() ?? '';
        if (productName.contains(query)) {
          return matchesFilter;
        }
      }
      
      // Check client name as fallback
      final clientName = transaction.client.name?.toLowerCase() ?? '';
      return clientName.contains(query) && matchesFilter;
    }).toList();

    Future<void> onRefresh() async {
      if (businessId != null) {
        await viewModel.fetchTransactions(businessId);
      }
    }

    return ResponsiveWrapper(
      child: KeyboardDismissibleScaffold(
        appBar: AppBar(

          centerTitle: false,
          title: Text(
            'All transactions (${filteredTransactions.length})',
            style: Theme.of(context).textTheme.displayLarge!,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: Column(
            children: [
              SizedBox(height: responsiveData.scaleHeight(32)),
              FadeInWidget(
                delay: const Duration(milliseconds: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppTextField(
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(responsiveData.scaleHeight(16)),
                          child: SvgPicture.asset(Assets.svg.search,colorFilter: ColorFilter.mode(
                            isDarkMode ? Colors.white : Colors.black,
                            BlendMode.srcIn,
                          ),),
                        ),
                        hintText: isServiceMode.value == null ? 'Search for transaction' : 
                                 (isServiceMode.value == true) ? 'Search for service' : 'Search for product',
                        controller: searchController,
                        radius: responsiveData.largeRadius,
                        filled: isDarkMode ? false: true,
                        appBorderColor: isDarkMode ? Colors.white : Colors.transparent,
                        fillColor: appGrey5,
                      ),
                    ),
                    SizedBox(width: responsiveData.scaleWidth(12)),
                    GestureDetector(
                      onTap: () {
                        buildFilterBottomSheet(context, filterType, isDarkMode);
                      },
                      child: Container(
                        height: responsiveData.scaleHeight(48),
                        width: responsiveData.scaleWidth(56),
                        decoration: BoxDecoration(
                          color: borderColor,
                          borderRadius: BorderRadius.circular(responsiveData.largeRadius),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(responsiveData.scaleHeight(14)),
                          child: SvgPicture.asset(Assets.svg.filter),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(16)),
              // Toggle switch between Products and Services
              Container(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsiveData.scaleWidth(4),
                    vertical: responsiveData.scaleHeight(2),
                  ),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          isServiceMode.value = null; // null represents 'All'
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsiveData.scaleWidth(12),
                            vertical: responsiveData.scaleHeight(6),
                          ),
                          decoration: BoxDecoration(
                            color: isServiceMode.value == null
                                ? primaryColor2
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                          ),
                          child: Text(
                            'All',
                            style: TextStyle(
                              color: isServiceMode.value == null
                                  ? Colors.white
                                  : isDarkMode ? Colors.white : Colors.black,
                              fontSize: Responsive.fontSize(context, 12),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => isServiceMode.value = false,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsiveData.scaleWidth(12),
                            vertical: responsiveData.scaleHeight(6),
                          ),
                          decoration: BoxDecoration(
                            color: isServiceMode.value == false
                                ? primaryColor2
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                          ),
                          child: Text(
                            'Products',
                            style: TextStyle(
                              color: isServiceMode.value == false
                                  ? Colors.white
                                  : isDarkMode ? Colors.white : Colors.black,
                              fontSize: Responsive.fontSize(context, 12),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => isServiceMode.value = true,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsiveData.scaleWidth(12),
                            vertical: responsiveData.scaleHeight(6),
                          ),
                          decoration: BoxDecoration(
                            color: isServiceMode.value == true
                                ? primaryColor2
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(responsiveData.smallRadius),
                          ),
                          child: Text(
                            'Services',
                            style: TextStyle(
                              color: isServiceMode.value == true
                                  ? Colors.white
                                  : isDarkMode ? Colors.white : Colors.black,
                              fontSize: Responsive.fontSize(context, 12),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(16)),
              Expanded(
                child: viewModel.isLoading
                    ? ListView.separated(
                        itemCount: 4,
                        separatorBuilder: (ctx, idx) => SizedBox(height: responsiveData.scaleHeight(24)),
                        itemBuilder: (_, index) => CustomShimmer(height: responsiveData.scaleHeight(101)),
                      )
                    : filteredTransactions.isEmpty
                        ? PullToRefresh(
                            onRefresh: onRefresh,
                            child: CustomScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                SliverFillRemaining(
                                  hasScrollBody: false,
                                  child: Column(
                                    children: [
                                      const Spacer(),
                                      SvgPicture.asset(Assets.svg.emptyTransaction, height: responsiveData.scaleHeight(200), width: responsiveData.scaleWidth(200)),
                                      SizedBox(height: responsiveData.scaleHeight(40)),
                                      Text(
                                        filterType.value != 'All' && viewModel.transactions.isNotEmpty
                                            ? 'No ${filterType.value}s found!'
                                            : isServiceMode.value == null
                                                ? 'No transactions yet!'
                                                : isServiceMode.value == true
                                                    ? 'No service transactions found!'
                                                    : 'No product transactions found!',
                                        style: Theme.of(context).textTheme.displayLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: responsiveData.scaleHeight(10)),
                                      Text(
                                        filterType.value != 'All' && viewModel.transactions.isNotEmpty
                                            ? 'Try adjusting your filter or search.'
                                            : viewModel.transactions.isEmpty
                                                ? 'Start generating receipts and invoices for your business. All transactions will show here.'
                                                : 'Try adjusting your search or filter settings.',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(fontSize: Responsive.fontSize(context, 14)),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : PullToRefresh(
                            onRefresh: onRefresh,
                            child: ListView.separated(
                              itemCount: filteredTransactions.length,
                              separatorBuilder: (ctx, idx) => SizedBox(height: responsiveData.scaleHeight(12)),
                              itemBuilder: (context, index) {
                                final transaction = filteredTransactions[index];
                                final firstProductDetail = transaction.recordProductDetails.isNotEmpty
                                    ? transaction.recordProductDetails.first
                                    : null;
                                final isInvoice = transaction.status == 'pending';

                                // Handle null product case
                                final product = firstProductDetail?.product;
                                final isService = firstProductDetail?.isService ?? false;
                                final productName = product?.name ?? 'Unknown ' + (isService ? 'Service' : 'Product');
                                final imageUrl = product?.logoUrl ?? "";
                                
                                // Use transaction total if product price is not available
                                final amount = (firstProductDetail != null && firstProductDetail.price != null)
                                    ? (double.tryParse(firstProductDetail.price ?? '0') ?? 0)
                                      .toString()
                                      .toCommaSeparated()
                                    : transaction.total.toString().toCommaSeparated();
                                    
                                final dateTime = transaction.createdAt
                                    .toString()
                                    .toFormattedIsoDate();
                                    
                                final unitSold = firstProductDetail?.quantity?.toString() ?? 
                                    product?.quantitySold?.toString() ?? '0';

                                return SlideInWidget(
                                  begin: const Offset(0, 0.3),
                                  delay: Duration(milliseconds: 100 + (index * 50)),
                                  child: GestureDetector(
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
                                          issuerSignatureUrl: transaction.business.issuerSignatureUrl,
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
                                        ReceiptScreenRoute(record: receipt, isInvoice: isInvoice, source: 'transactions'),
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
                                      imageUrl: imageUrl,
                                      isService: isService,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<dynamic> buildFilterBottomSheet(
      BuildContext context, ValueNotifier<String> filterType, bool isDarkMode) {
    final responsiveData = ResponsiveInherited.of(context);

    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) {
        return Container(
          height: responsiveData.scaleHeight(326),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(responsiveData.largeRadius),
              topLeft: Radius.circular(responsiveData.largeRadius),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: responsiveData.paddingHorizontal,
                vertical: responsiveData.scaleHeight(10)),
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
                          borderRadius: BorderRadius.circular(responsiveData.largeRadius),
                        ),
                      ),
                    ),
                    SizedBox(height: responsiveData.scaleHeight(38)),
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
                              fontSize: Responsive.fontSize(context, 22),
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
                    SizedBox(height: responsiveData.scaleHeight(12)),
                    Center(
                      child: Text(
                        "Select transaction type you'll like to see.",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    SizedBox(height: responsiveData.scaleHeight(40)),
                    InkWell(
                      onTap: () {
                        filterType.value = 'Receipt';
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              Assets.svg.receipt,
                              colorFilter: ColorFilter.mode(
                                  isDarkMode ? Colors.white : Colors.black,
                                  BlendMode.srcIn),
                            ),
                            SizedBox(width: responsiveData.scaleWidth(16)),
                            Text(
                              'Receipt',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: Responsive.fontSize(context, 14)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: responsiveData.scaleHeight(1)),
                    InkWell(
                      onTap: () {
                        filterType.value = 'Invoice';
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                                Assets.svg.invoice,
                                colorFilter: ColorFilter.mode(
                                    isDarkMode ? Colors.white : Colors.black,
                                    BlendMode.srcIn)),
                            SizedBox(width: responsiveData.scaleWidth(16)),
                            Text(
                              'Invoice',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: Responsive.fontSize(context, 14)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(height: responsiveData.scaleHeight(1)),
                    InkWell(
                      onTap: () {
                        filterType.value = 'All';
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.all_inclusive,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            SizedBox(width: responsiveData.scaleWidth(16)),
                            Text(
                              'All',
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
              ],
            ),
          ),
        );
      },
    );
  }
}