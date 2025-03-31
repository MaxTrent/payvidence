import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payvidence/providers/client_providers/get_all_client_provider.dart';
import 'package:payvidence/utilities/toast_service.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../constants/app_colors.dart';
import '../../data/local/session_constants.dart';
import '../../data/local/session_manager.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'ClientsRoute')
class Clients extends ConsumerWidget {
  final bool? forSelection;

  Clients({super.key, this.forSelection = false});

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allClients = ref.watch(getAllClientsProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          'Clients',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(),
        ),
        actions: [
          Center(
              child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: GestureDetector(
                      onTap: () {
                        locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.addClient);
                      },
                      child: Text('+ Add New',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  fontSize: 14.sp, color: primaryColor2)))))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
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
              hintText: 'Search for client',
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

            allClients.when(data: (data) {
              if (data.isEmpty) {
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'No clients available!',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text('All added clients will appear here.',
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
                          buttonText: 'Add client',
                          onPressed: () {
                            locator<PayvidenceAppRouter>()
                                .navigateNamed(PayvidenceRoutes.addClient);
                          })
                    ],
                  ),
                );
              }

              return ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (forSelection == true) {
                          Navigator.of(context).pop(data[index]);
                        } else {
                          if (data[index].id != null) {
                            final businessId = locator<SessionManager>().get(SessionConstants.businessId) as String?;
                            print("Navigating to ClientDetails with businessId: $businessId");
                            locator<PayvidenceAppRouter>().push(ClientDetailsRoute(clientId: data[index].id!));
                          } }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 56.h,
                            width: 56.h,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.lightGreen),
                            child: Center(
                                child: Text(
                              '${data[index].name?.substring(0,2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      fontSize: 20.sp, color: Colors.white),
                            )),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data[index].name??'',
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset(Assets.svg.location),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    Expanded(
                                      child: Text(
                                        data[index].address??'',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall!
                                            .copyWith(fontSize: 14.sp),
                                        // maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        // softWrap: true,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      data[index].phoneNumber??'',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall!
                                          .copyWith(fontSize: 14.sp),
                                    ),
                                    SizedBox(
                                      width: 8.w,
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        Clipboard.setData(ClipboardData(text: data[index].phoneNumber??''));
ToastService.showSnackBar('Copied to clipboard');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                           SnackBar(content: Text('Copied to clipboard', style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.white, fontWeight: FontWeight.w400),), backgroundColor: primaryColor2,),
                                        );
                                      },
                                        child: SvgPicture.asset(Assets.svg.copy))
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
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
                  itemCount: data.length);
            }, error: (error, _) {
              return const Text('An error has occurred');
            }, loading: () {
              return const CustomShimmer();
            })
          ],
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
