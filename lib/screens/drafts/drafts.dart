import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:payvidence/providers/receipt_providers/get_all_invoice_provider.dart';
import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../components/loading_dialog.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../model/receipt_model.dart';
import '../../providers/receipt_providers/get_all_receipt_provider.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/theme_mode.dart';
import '../../utilities/toast_service.dart';

@RoutePage(name: 'DraftsRoute')
class Drafts extends HookConsumerWidget {
  final bool? isInvoice;

  Drafts({super.key, this.isInvoice = false});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;

    final allReceipts = isInvoice == true
        ? ref.watch(getAllInvoiceProvider)
        : ref.watch(getAllReceiptProvider);

    Future<void> deleteProduct(String id) async {
      if (!context.mounted) return;
      LoadingDialog.show(context);
      try {
        final response =
            await ref.read(getAllReceiptProvider.notifier).deleteDraft(id);
        if (!context.mounted) return;
        Navigator.of(context).pop(); //pop loading dialog on success
        ToastService.showSnackBar("Draft deleted successfully");
        ref.invalidate(
            isInvoice == true ? getAllInvoiceProvider : getAllReceiptProvider);
        Future.delayed(const Duration(seconds: 2), () {
          // if (!context.mounted) return;
          // context.router.back();
          //  context.router.pushAndPopUntil(const HomePageRoute(), predicate: (route)=>route.settings.name == '/');
        });
      } on DioException catch (e) {
        Navigator.of(context).pop(); // pop loading dialog on error
        ToastService.showErrorSnackBar(
            e.response?.data['message'] ?? 'An unknown error has occurred!!!');
      } catch (e) {
        print(e);
        Navigator.of(context).pop(); // pop loading dialog on error
        ToastService.showErrorSnackBar('An unknown error has occurred!');
      }
    }

    ValueNotifier<int?> productNumber = ValueNotifier(null);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: ValueListenableBuilder(
          builder: (context, value, _) {
            return Text(
              'All drafts (${value ?? '0'})',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(),
            );
          },
          valueListenable: productNumber,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 32.h,
              ),
              AppTextField(
                // width: 282.w,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(16.h),
                  child: SvgPicture.asset(Assets.svg.search,  colorFilter: ColorFilter.mode(isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn),),
                ),
                hintText: 'Search for product',
                controller: _searchController,
                radius: 80,
                filled: true,
                fillColor: isDarkMode ? Colors.black : appGrey5,
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
                    data.where((data) => data.publishedAt == null).toList();

                if (actualData.isEmpty) {
                  productNumber.value = 0;

                  return SizedBox(
                    width: ScreenUtil().screenWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: ScreenUtil().screenHeight / 4,
                        ),

                        Text(
                          'No receipts in drafts!',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text('All receipts in drafts will appear here.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                  fontSize: 14.sp,
                                )),
                        // SizedBox(
                        //   height: 48.h,
                        // ),
                        // AppButton(
                        //     buttonText: 'Generate receipt',
                        //     onPressed: () {
                        //       locator<PayvidenceAppRouter>().navigateNamed(
                        //           PayvidenceRoutes.generateReceipt);
                        //     })
                      ],
                    ),
                  );
                }

                productNumber.value = actualData.length;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You can click on specific draft to edit.',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return DraftTile(
                            draft: actualData[index],
                            onPressed: (String id) {
                              deleteProduct(id);
                            },
                            isInvoice: isInvoice ?? false,
                          );
                        },
                        separatorBuilder: (ctx, idx) {
                          return Column(
                            children: [
                              SizedBox(
                                height: 24.h,
                              ),
                            ],
                          );
                        },
                        itemCount: actualData.length),
                    SizedBox(
                      height: 40.h,
                    )
                  ],
                );
              }, error: (error, _) {
                return const Text('An error has occurred');
              }, loading: () {
                return const CustomShimmer();
              })
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: primaryColor2,
      //   child: Icon(
      //     Icons.add,
      //     size: 40.h,
      //   ),
      // ),
      // AppButton(buttonText: 'Generate receipt', onPressed: (){
      //   // context.push('/addBusiness');
      // }),
    );
  }
}

class DraftTile extends StatelessWidget {
  final void Function(String id) onPressed;
  final Receipt draft;
  final bool isInvoice;

  const DraftTile(
      {super.key,
      required this.draft,
      required this.onPressed,
      required this.isInvoice});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        locator<PayvidenceAppRouter>()
            .navigate(CompleteDraftRoute(draft: draft, isInvoice: isInvoice));
      },
      child: Container(
        height: 101.h,
        width: ScreenUtil().screenWidth,
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Row(
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
                    draft.recordProductDetails?[0].product?.name ?? '',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Row(
                    children: [
                      Text(
                          '${draft.recordProductDetails?[0].quantity ?? ''} units sold',
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
                            DateFormat.yMd().add_jm().format(draft.createdAt!),
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 14.sp, color: appGrey4)),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                          onTap: () {
                            onPressed.call(draft.id ?? '');
                          },
                          child: SvgPicture.asset(Assets.svg.delete)),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Row(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('₦${draft.recordProductDetails?[0].total ?? ''} ',
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
        ),
      ),
    );
  }
}
