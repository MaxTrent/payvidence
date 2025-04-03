import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:payvidence/model/receipt_model.dart';
import 'package:payvidence/providers/receipt_providers/get_all_receipt_provider.dart';
import '../../components/app_button.dart';
import '../../components/app_naira.dart';
import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'AllReceiptsRoute')
class AllReceipts extends ConsumerWidget {
  AllReceipts({super.key});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allReceipts = ref.watch(getAllReceiptProvider);
    ValueNotifier<int?> productNumber = ValueNotifier(null);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: ValueListenableBuilder(
          builder: (context, value, _) {
            return Text(
              'All receipts (${value ?? ''})',
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
                  locator<PayvidenceAppRouter>()
                      .navigateNamed(PayvidenceRoutes.drafts);
                },
                child: Text('View drafts',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 14.sp, color: primaryColor2))),
          ))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
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
                hintText: 'Search for receipt',
                controller: _searchController,
                radius: 80,
                filled: true,
                fillColor: appGrey5,
              ),
              SizedBox(
                height: 20.h,
              ),
              // SvgPicture.asset(Assets.svg.emptyReceipt),
              // SizedBox(height: 40.h,),
              // Text('No receipt yet!', style: Theme.of(context).textTheme.displayLarge,),
              // SizedBox(height: 10.h,),
              // Text('Generate receipts for your business sales. All receipts generated will show here.',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, )),
              allReceipts.when(data: (data) {
                final actualData =
                    data.where((data) => data.publishedAt != null).toList();

                if (actualData.isEmpty) {
                  productNumber.value = 0;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: ScreenUtil().screenHeight / 4,
                      ),
                      Text(
                        'No receipts available!',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text('All added receipts will appear here.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                fontSize: 14.sp,
                              )),
                      SizedBox(
                        height: 48.h,
                      ),
                      AppButton(
                          buttonText: 'Generate receipt',
                          onPressed: () {
                            locator<PayvidenceAppRouter>().navigateNamed(
                                PayvidenceRoutes.generateReceipt);
                          })
                    ],
                  );
                }
                productNumber.value = actualData.length;

                return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () {
                            locator<PayvidenceAppRouter>()
                                .navigate(ReceiptScreenRoute(
                              record: actualData[index],
                              isInvoice: false,
                            ));
                          },
                          child: ReceiptTile(
                            receipt: actualData[index],
                          ));
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
              })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          locator<PayvidenceAppRouter>()
              .navigateNamed(PayvidenceRoutes.generateReceipt);
        },
        backgroundColor: primaryColor2,
        child: Icon(
          Icons.add,
          size: 40.h,
        ),
      ),
      // AppButton(buttonText: 'Generate receipt', onPressed: (){
      //   // context.push('/addBusiness');
      // }),
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
        SizedBox(
          width: 14.w,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                receipt.recordProductDetails?[0].product?.name ?? '',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(
                height: 6.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                      '${receipt.recordProductDetails?[0].quantity ?? ''} units sold',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: 14.sp, color: appGrey4)),
                  SizedBox(
                    width: 10.w,
                  ),
                  Container(
                    height: 6.h,
                    width: 6.h,
                    decoration: BoxDecoration(
                        color: appGrey4,
                        borderRadius: BorderRadius.circular(24.r)),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Text(
                        DateFormat.yMd().add_jm().format(receipt.createdAt!),
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(fontSize: 14.sp, color: appGrey4)),
                  ),
                ],
              ),
              SizedBox(
                height: 8.h,
              ),
              Row(
                // mainAxisSize: MainAxisSize.min,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppNaira(fontSize: 14,),
                  Text('${receipt.recordProductDetails?[0].total ?? ''} ',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontSize: 14.sp)),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
