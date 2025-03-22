import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../providers/receipt_providers/get_all_invoice_provider.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../all_receipts/all_receipts.dart';

@RoutePage(name: 'AllInvoicesRoute')
class AllInvoices extends ConsumerWidget {
  AllInvoices({super.key});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allInvoices = ref.watch(getAllInvoiceProvider);
    ValueNotifier<int?> productNumber = ValueNotifier(null);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: ValueListenableBuilder(
          builder: (context, value, _) {
            return Text(
              'All invoices (${value ?? ''})',
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
                  context.router.push(DraftsRoute(isInvoice: true));
                },
                child: Text('View drafts',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 14.sp, color: primaryColor2))),
          ))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 32.h,
              ),
              AppTextField(
                // width: 282.w,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(16.h),
                  child: SvgPicture.asset(Assets.svg.search),
                ),
                hintText: 'Search for invoice',
                controller: _searchController,
                radius: 80,
                filled: true,
                fillColor: appGrey5,
              ),

              allInvoices.when(data: (data) {
                final actualData =
                    data.where((data) => data.publishedAt != null).toList();
                if (actualData.isEmpty) {
                  productNumber.value = 0;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.svg.emptyInvoice),
                      SizedBox(
                        height: 40.h,
                      ),
                      Text(
                        'No invoice yet!',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                          'Generate invoice for your business pending sales. All invoices generated will show here.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                fontSize: 14.sp,
                              )),
                    ],
                  );
                }
                productNumber.value = actualData.length;

                return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ReceiptTile(
                        receipt: actualData[index],
                      );
                    },
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (ctx, idx) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 24.h,
                          ),
                        ],
                      );
                    },
                    itemCount: actualData.length);
              }, error: (error, _) {
                return const Text('An error has occurred');
              }, loading: () {
                return const CustomShimmer();
              }),

              // ReceiptTile(),
              // ReceiptTile(),
              // ReceiptTile(),
              // ReceiptTile(),
              // ReceiptTile(),
              // ReceiptTile(),
              // ReceiptTile(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          locator<PayvidenceAppRouter>()
              .navigate(GenerateReceiptRoute(isInvoice: true));
        },
        backgroundColor: primaryColor2,
        child: Icon(
          Icons.add,
          size: 40.h,
        ),
      ),
      // AppButton(buttonText: 'Generate invoice', onPressed: (){
      //   // context.push('/addBusiness');
      // }),
    );
  }
}
