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
import 'package:payvidence/providers/product_providers/current_product_provider.dart';
import 'package:payvidence/providers/product_providers/get_all_product_provider.dart';
import 'package:payvidence/utilities/animations.dart';
import 'package:payvidence/utilities/extensions.dart';
import '../../components/app_button.dart';
import '../../components/app_naira.dart';
import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../components/pull_to_refresh.dart';
import '../../components/simple_bottom_sheet.dart';
import '../../utilities/toast_service.dart';
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
    return _AllReceiptsContent();
  }
}

class _AllReceiptsContent extends HookConsumerWidget {
  _AllReceiptsContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allReceipts = ref.watch(getAllReceiptProvider);
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final searchController = useTextEditingController();
    final searchQuery = useState<String>('');
    final productNumber = ValueNotifier<int?>(null);
    final isServiceMode = useState<bool?>(null); // null represents 'All'
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
        floatingActionButton: ValueListenableBuilder(
          valueListenable: productNumber,
          builder: (context, value, _) {
            if ((value ?? 0) > 0) {
              return FloatingActionButton(
                onPressed: () {
                  ref.read(getCurrentProductProvider.notifier).state = null;
                  locator<PayvidenceAppRouter>()
                      .navigate(SelectTypeRoute(isInvoice: false));
                },
                backgroundColor: primaryColor2,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
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
                  hintText: isServiceMode.value == null ? 'Search for product or service' : 
                           (isServiceMode.value == true) ? 'Search for service' : 'Search for product',
                  controller: searchController,
                  radius: responsiveData.largeRadius,
                  filled: isDarkMode ? false : true,
                  fillColor: isDarkMode ? Colors.black : appGrey5,
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(16)),
              // Toggle switch between Products and Services - only shown when both types exist
              allReceipts.maybeWhen(
                data: (data) {
                  final hasProducts = data.any((item) => 
                    item.publishedAt != null && 
                    !(item.recordProductDetails.any((detail) => detail.isService ?? false)));
                  
                  final hasServices = data.any((item) => 
                    item.publishedAt != null && 
                    item.recordProductDetails.any((detail) => detail.isService ?? false));
                  
                  // Always show toggle if there's at least one receipt
                  return Column(
                    children: [
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
                    ],
                  );
                },
                orElse: () => SizedBox(height: 0),
              ),
              Expanded(
                child: allReceipts.when(
                  data: (data) {
                    final actualData = data.where((data) => data.publishedAt != null).toList()
                      ..sort((a, b) => (b.createdAt ?? DateTime(1970)).compareTo(a.createdAt ?? DateTime(1970)));
                    // Filter by service/product type and search query
                    final filteredData = actualData
                        .where((receipt) {
                          // Skip receipts with empty product details
                          if (receipt.recordProductDetails.isEmpty) {
                            return false;
                          }
                          
                          // First filter by service/product type if not 'All'
                          if (isServiceMode.value != null) {
                            bool isService = receipt.recordProductDetails.any((detail) => 
                              detail.isService ?? false);
                            
                            if (isServiceMode.value != isService) {
                              return false;
                            }
                          }
                          
                          // Then filter by search query if needed
                          if (searchQuery.value.isEmpty) {
                            return true;
                          }
                          
                          final productName = receipt.recordProductDetails[0].product?.name;
                          if (productName == null) {
                            return false;
                          }
                          
                          return productName.toLowerCase().contains(searchQuery.value.toLowerCase());
                        })
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
                                          ref.read(getCurrentProductProvider.notifier).state = null;
                                          locator<PayvidenceAppRouter>()
                                              .navigate(SelectTypeRoute(isInvoice: false));
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
                                    title: 'Delete Receipt',
                                    subtitle: 'Are you sure you want to delete this receipt?',
                                    height: responsiveData.scaleHeight(500),
                                    children: [
                                      InkWell(
                                        onTap: () => Navigator.of(context).pop(true),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                                          child: Row(
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
                                      InkWell(
                                        onTap: () => Navigator.of(context).pop(false),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
                                          child: Row(
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
                                    await ref.read(getAllReceiptProvider.notifier).deleteDraft(filteredData[index].id!);
                                    return true;
                                  } catch (e) {
                                    String errorMessage = 'Failed to delete receipt';
                                    if (e.toString().contains('forbidden') || e.toString().contains('cannot delete published record')) {
                                      errorMessage = 'Cannot delete published receipt';
                                    }
                                    ToastService.showErrorSnackBar(errorMessage);
                                    return false;
                                  }
                                }
                                return false;
                              },
                              onDismissed: (direction) {
                                ref.invalidate(getAllReceiptProvider);
                              },
                              child: GestureDetector(
                                onTap: () {
                                  locator<PayvidenceAppRouter>().navigate(
                                    TransactionDetailsRoute(
                                      transaction: filteredData[index],
                                      isInvoice: false,
                                    ),
                                  );
                                },
                                child: ReceiptTile(
                                  receipt: filteredData[index],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (ctx, idx) {
                          return SizedBox(
                            height: responsiveData.scaleHeight(12),
                          );
                        },
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
                                : 'Unable to load receipts. Please try again.',
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
      ),
    );
  }
}

class ReceiptTile extends ConsumerWidget {
  final Receipt receipt;

  const ReceiptTile({super.key, required this.receipt});
  
  String _getDisplayName(Receipt receipt, WidgetRef ref) {
    if (receipt.recordProductDetails.isEmpty) {
      return 'Unknown Item';
    }
    
    final detail = receipt.recordProductDetails[0];
    final isService = detail.isService ?? false;
    
    // If product object exists and has a name
    if (detail.product?.name != null && 
        detail.product!.name!.isNotEmpty) {
      return detail.product!.name!;
    }
    
    // If we need to look up the product name
    if (!isService && detail.productId != null) {
      // Try to find the product in the products list
      final allProducts = ref.watch(getAllProductProvider).valueOrNull;
      if (allProducts != null) {
        for (final product in allProducts) {
          if (product.id == detail.productId) {
            return product.name ?? "Product";
          }
        }
      }
    }
    
    // If we know it's a service but don't have a name
    if (isService) {
      return 'Service';
    }
    
    // For products without a name
    return 'Product';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responsiveData = ResponsiveInherited.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    // Check if recordProductDetails is empty
    if (receipt.recordProductDetails.isEmpty) {
      return Container(
        height: responsiveData.scaleHeight(72),
        padding: EdgeInsets.all(responsiveData.scaleHeight(8)),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800]!.withOpacity(0.3) : Colors.grey[200],
          borderRadius: BorderRadius.circular(responsiveData.smallRadius),
        ),
        child: Center(
          child: Text(
            'Receipt details unavailable',
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              height: responsiveData.scaleHeight(72),
              width: responsiveData.scaleHeight(72),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[700],
              ),
              child: (receipt.recordProductDetails[0].product?.logoUrl != null && 
                     receipt.recordProductDetails[0].product!.logoUrl!.isNotEmpty)
                  ? Image.network(
                    receipt.recordProductDetails[0].product!.logoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        Assets.png.payvidenceLogo.path,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                  : Image.asset(
                    Assets.png.payvidenceLogo.path,
                    fit: BoxFit.cover,
                  ),
            ),
            if (receipt.isCancelled == true)
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(3)),
                child: Container(
                  height: responsiveData.scaleHeight(23),
                  // width: responsiveData.scaleHeight(72),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(responsiveData.radius)
                  ),
                  child: Center(
                    child: Text(
                      'Cancelled',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: Responsive.fontSize(context, 12), color: appRed)

                    ),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(width: responsiveData.scaleWidth(14)),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getDisplayName(receipt, ref),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.w600
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(6)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    receipt.recordProductDetails[0].isService ?? false
                        ? 'Completed'
                        : '${receipt.recordProductDetails[0].quantity ?? '0'} units sold',
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
                      receipt.createdAt != null 
                          ? DateFormat.yMd().add_jm().format(receipt.createdAt!) 
                          : 'Unknown date',
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
                  AppNaira(fontSize: 14, color: isDarkMode ? Colors.white : Colors.black),
                  Text(
                    '${(double.tryParse(receipt.recordProductDetails[0].total ?? '0') ?? 0).toString().toCommaSeparated() ?? '0'} ',
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