import 'dart:developer' as developer;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/custom_shimmer.dart';
import 'package:payvidence/components/loading_indicator.dart';
import 'package:payvidence/components/pull_to_refresh.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/data/local/session_constants.dart';
import 'package:payvidence/data/local/session_manager.dart';
import 'package:payvidence/providers/business_providers/current_business_provider.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/all_transactions/all_transactions_vm.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import '../../components/app_card.dart';
import '../../components/transaction_tile.dart';
import '../../gen/assets.gen.dart';
import '../../providers/business_providers/get_all_business_provider.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/extensions.dart';
import '../my_subscription/my_subscription_vm.dart';

@RoutePage(name: 'HomeScreenRoute')
class HomeScreen extends HookConsumerWidget {
  final VoidCallback onViewAllTransactions;
  const HomeScreen({super.key, required this.onViewAllTransactions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsViewModel = ref.watch(allTransactionsViewModelProvider);
    final getAllBusiness = ref.watch(getAllBusinessProvider);
    final useMySubscriptionViewModel = ref.watch(mySubscriptionViewModel);

    useEffect(() {
      getAllBusiness.when(
        data: (businesses) {
          if (businesses.isEmpty) {
            developer.log('🏠 HomeScreen: No businesses found, navigating to EmptyBusinessRoute');
            Future.microtask(() {
              locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.emptyBusiness);
            });
          } else {
            developer.log('🏠 HomeScreen: Setting current business: ${businesses.last.name}');

            Future.microtask(() {
              ref.read(getCurrentBusinessProvider.notifier).setCurrentBusiness(businesses.last);

              final businessId = businesses.last.id;
              locator<SessionManager>().save(key: SessionConstants.businessId, value: businessId);

              if (businessId != null) {
                transactionsViewModel.fetchTransactions(businessId);
              }
            });
          }
        },
        loading: () {
          developer.log('Still loading businesses...');
        },
        error: (error, stackTrace) {
          developer.log('Error loading businesses: $error');
        },
      );

      return null;
    }, [getAllBusiness]);

    Future<void> onRefresh() async {
      final businessId = ref.watch(getCurrentBusinessProvider)?.id;
      if (businessId != null) {
        await transactionsViewModel.fetchTransactions(businessId);
      }
    }

    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
            child: PullToRefresh(
              onRefresh: onRefresh,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(height: responsiveData.scaleHeight(8)),
                  getAllBusiness.when(
                    data: (data) {
                      if (data.isEmpty) {
                        return const Center(
                          child: LoadingIndicator(),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: responsiveData.smallRadius * 1.6,
                                backgroundColor: Colors.black,
                                backgroundImage: NetworkImage(data.last.logoUrl ?? ''),
                              ),
                              SizedBox(width: responsiveData.scaleWidth(10)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (() {
                                      final name = ref.watch(getCurrentBusinessProvider)?.name ?? '...';
                                      return name.length > 14 ? '${name.substring(0, 14)}...' : name;
                                    })(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall!
                                        .copyWith(fontSize: Responsive.fontSize(context, 14)),
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(Assets.svg.ribbon),
                                      SizedBox(width: responsiveData.scaleWidth(2)),
                                      Text(
                                        'Starter plan',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(fontSize: Responsive.fontSize(context, 12)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: responsiveData.scaleWidth(15)),
                          GestureDetector(
                            onTap: () {
                              locator<PayvidenceAppRouter>().push(const AllBusinessesRoute());
                            },
                            child: Container(
                              height: responsiveData.scaleHeight(40),
                              width: responsiveData.scaleWidth(157),
                              decoration: BoxDecoration(
                                color: appGrey2,
                                borderRadius: BorderRadius.circular(responsiveData.smallRadius * 1.2),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(12)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Switch business',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                        fontSize: Responsive.fontSize(context, 14),
                                        color: Colors.black,
                                      ),
                                    ),
                                    SvgPicture.asset(Assets.svg.store),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    error: (error, _) => const Text("Error fetching businesses"),
                    loading: () => const CustomShimmer(),
                  ),

                  SizedBox(height: responsiveData.scaleHeight(32)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.allReceipts);
                        },
                        child: AppCard(text: 'Receipts', icon: Assets.svg.receipt),
                      ),
                      GestureDetector(
                        onTap: () {
                          locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.allInvoices);
                        },
                        child: AppCard(text: 'Invoices', icon: Assets.svg.invoice),
                      ),
                      GestureDetector(
                        onTap: () {
                          final businessId = ref.watch(getCurrentBusinessProvider)?.id;
                          locator<PayvidenceAppRouter>().navigate(ClientsRoute(businessId: businessId!));
                        },
                        child: AppCard(text: 'Clients', icon: Assets.svg.client),
                      ),
                      GestureDetector(
                        onTap: () {
                          locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.product);
                        },
                        child: AppCard(text: 'Products', icon: Assets.svg.product),
                      ),
                    ],
                  ),
                  SizedBox(height: responsiveData.scaleHeight(38)),
                  useMySubscriptionViewModel.subInfo?.plan.name != null
                      ? const SizedBox.shrink()
                      : GestureDetector(
                    onTap: () => locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.chooseSubscriptionPlan),
                    child: SvgPicture.asset(Assets.svg.subscribe),
                  ),
                  SizedBox(height: responsiveData.scaleHeight(40)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent transactions',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      GestureDetector(
                        onTap: onViewAllTransactions,
                        child: Text(
                          'View all',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontSize: Responsive.fontSize(context, 12)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsiveData.scaleHeight(24)),
                  if (transactionsViewModel.isLoading) ...[
                    CustomShimmer(height: responsiveData.scaleHeight(101)),
                    SizedBox(height: responsiveData.scaleHeight(24)),
                    CustomShimmer(height: responsiveData.scaleHeight(101)),
                  ] else if (transactionsViewModel.transactions.isEmpty) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: responsiveData.scaleHeight(24)),
                        SvgPicture.asset(Assets.svg.emptyTransaction, height: responsiveData.scaleHeight(160), width: responsiveData.scaleWidth(160)),
                        SizedBox(height: responsiveData.scaleHeight(32)),
                        Text(
                          'No transaction yet!',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        SizedBox(height: responsiveData.scaleHeight(10)),
                        Text(
                          'Start generating receipts and invoices for your business. All transactions will show here.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(fontSize: Responsive.fontSize(context, 14)),
                        ),
                      ],
                    ),
                  ] else ...[
                    ...transactionsViewModel.transactions.take(5).map(
                          (transaction) {
                        final firstProductDetail =
                        transaction.recordProductDetails.isNotEmpty
                            ? transaction.recordProductDetails.first
                            : null;

                        if (firstProductDetail == null) {
                          return TransactionTile(
                            amount: '0',
                            dateTime: '',
                            productName: 'Unknown Product',
                            receiptOrInvoice: transaction.status == 'pending'
                                ? 'Invoice'
                                : 'Receipt',
                            unitSold: '0',
                            imageUrl: '',
                          );
                        }

                        final product = firstProductDetail.product;
                        final productName = product?.name ?? 'Unknown Product';
                        final amount = product != null
                            ? (double.tryParse(product.price ?? '0') ?? 0)
                            .toString()
                            .toCommaSeparated()
                            : '0';
                        final imageUrl = product?.logoUrl ?? "";
                        final dateTime = product?.createdAt
                            ?.toString()
                            .toFormattedIsoDate() ??
                            '';
                        final unitSold = product?.quantitySold?.toString() ?? '0';

                        return TransactionTile(
                          amount: amount,
                          dateTime: dateTime,
                          productName: productName,
                          receiptOrInvoice: transaction.status == 'pending'
                              ? 'Invoice'
                              : 'Receipt',
                          unitSold: unitSold,
                          imageUrl: imageUrl,
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}