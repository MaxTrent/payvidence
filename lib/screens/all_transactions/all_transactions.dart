import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/data/local/session_constants.dart';
import 'package:payvidence/data/local/session_manager.dart';
import 'package:payvidence/screens/all_transactions/all_transactions_vm.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/extensions.dart';
import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../components/transaction_tile.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';


@RoutePage(name: 'AllTransactionsRoute')
class AllTransactions extends HookConsumerWidget {
   AllTransactions({super.key});
  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(allTransactionsViewModelProvider);
    final searchController = useTextEditingController();
    final businessId = locator<SessionManager>().get(SessionConstants.businessId);

    useEffect(() {
      if (businessId != null) {
        Future.delayed(Duration.zero, () {
          print('Fetching transactions with businessId: $businessId');
          viewModel.fetchTransactions(businessId);
        });
      } else {
        print('Business ID is null, skipping fetch');
      }
      return null;
    }, [businessId]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('All transactions (${viewModel.transactions.length})', style: Theme.of(context).textTheme.displayLarge!.copyWith(),),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 32.h,),
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
                        buildFilterBottomSheet(context);
                      },
                      child: Container(
                        height: 48.h,
                        width: 56.w,
                        decoration: BoxDecoration(
                            color: borderColor,
                            borderRadius: BorderRadius.circular(56.r)),
                        child: Padding(
                          padding: EdgeInsets.all(14.h),
                          child: SvgPicture.asset(Assets.svg.filter),
                        ),
                      ),
                    ),
                  ],
                ),
                if (viewModel.isLoading) ...[
                  CustomShimmer(height: 101.h),
                  SizedBox(height: 24.h),
                  CustomShimmer(height: 101.h),
                  SizedBox(height: 24.h),
                  CustomShimmer(height: 101.h),
                  SizedBox(height: 24.h),
                  CustomShimmer(height: 101.h),
                ]else if (viewModel.transactions.isEmpty) ...[
                  SizedBox(height: 20.h),
                  SvgPicture.asset(Assets.svg.emptyTransaction),
                  SizedBox(height: 40.h),
                  Text(
                    'No transaction yet!',
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Start generating receipts and invoices for your business. All transactions will show here.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp),
                  ),
                ]
                else ...[
                  ...viewModel.transactions.map(
                        (transaction) => GestureDetector(
                          onTap: () {
                            // locator<PayvidenceAppRouter>().push(
                            //     SubscriptionPlansRoute(planId: plan.id));
                                },
                          child: TransactionTile(amount: transaction.recordProductDetails.first.product.price.toString().toCommaSeparated(), dateTime: transaction.recordProductDetails.first.product.createdAt.toString().toFormattedIsoDate(), productName: transaction.recordProductDetails.first.product.name, receiptOrInvoice: transaction.status == "pending"? "Receipt":"Invoice", unitSold: transaction.recordProductDetails.first.product.quantitySold.toString(),)

                        ),
                  ),
                ],

                 ],
            ),
          ],
        ),
      ),
      // floatingActionButton:
      // FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: primaryColor2,
      //   child: Icon(
      //     Icons.add,
      //     size: 40.h,
      //   ),
      // ),
      // AppButton(buttonText: 'Generate invoice', onPressed: (){
      //   // context.push('/addBusiness');
      // }),

    );
  }

   Future<dynamic> buildFilterBottomSheet(BuildContext context) {
     return showModalBottomSheet(
         isScrollControlled: true,
         backgroundColor: Colors.transparent,
         clipBehavior: Clip.none,
         context: context,
         builder: (context) {
           return Container(
             height: 326.h,
             decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.only(
                     topRight: Radius.circular(40.r),
                     topLeft: Radius.circular(40.r))),
             child: Padding(
               padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
               child: Stack(
                 children: [
                   ListView(
                     // crossAxisAlignment: CrossAxisAlignment.start,
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
                       SizedBox(
                         height: 38.h,
                       ),
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
                               child: const Icon(
                                 Icons.close,
                               ))
                         ],
                       ),
                       SizedBox(
                         height: 12.h,
                       ),
                       Center(
                         child: Text(
                           'Select transaction type you’ll like to see.',
                           style: Theme.of(context).textTheme.displaySmall,
                         ),
                       ),
                       SizedBox(
                         height: 40.h,
                       ),
                       Padding(
                         padding: EdgeInsets.symmetric(vertical: 24.h),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             SvgPicture.asset(Assets.svg.shapes),
                             SizedBox(
                               width: 16.w,
                             ),
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
                       Divider(
                         height: 1.h,
                       ),
                       Padding(
                         padding: EdgeInsets.symmetric(vertical: 24.h),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             SvgPicture.asset(Assets.svg.shapes),
                             SizedBox(
                               width: 16.w,
                             ),
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
                       Divider(
                         height: 1.h,
                       ),
                     ],
                   ),
                 ],
               ),
             ),
           );
         });
   }
}

