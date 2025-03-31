import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/screens/client_details/client_details_vm.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../constants/app_colors.dart';
import '../../data/local/session_constants.dart';
import '../../data/local/session_manager.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'ClientDetailsRoute')
class ClientDetails extends HookConsumerWidget {
  final String clientId;
  final String businessId;

  const ClientDetails(
      {super.key,
      @QueryParam('businessId') this.businessId = '',
      @QueryParam('clientId') this.clientId = ''});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(clientDetailsViewModelViewModelProvider);
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final nameController = useTextEditingController();
    final phoneNumberController = useTextEditingController();
    final addressController = useTextEditingController();
    final originalName = useState("");
    // final businessId =
    //     locator<SessionManager>().get(SessionConstants.businessId) as String?;

    useEffect(() {
      Future.microtask(
          () => viewModel.fetchClientDetails(businessId, clientId));
      return null;
    }, [businessId, clientId]);

    useEffect(() {
      if (viewModel.clientInfo != null && !viewModel.isLoading) {
        nameController.text = viewModel.clientInfo?.name ?? "";
        phoneNumberController.text = viewModel.clientInfo?.phoneNumber ?? '';
        addressController.text = viewModel.clientInfo?.address ?? '';
        originalName.value = viewModel.clientInfo?.name ?? "";
        print("Controllers set with clientInfo: ${viewModel.clientInfo!.name}");
      }
      return null;
    }, [viewModel.clientInfo, viewModel.isLoading]);

    print('BUSINESSID: $businessId, CLIENTID: $clientId');
    bool hasChanges() {
      return nameController.text != originalName.value;
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SafeArea(
            child: Form(
              key: formKey,
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    'Client details',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    'You can update or remove client details.',
                    style: Theme.of(context).textTheme.displaySmall!,
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  if (viewModel.isLoading) ...[
                    Text(
                      'Client name',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    CustomShimmer(height: 50.h),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'Client phone number',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    CustomShimmer(height: 50.h),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'Client address',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    CustomShimmer(height: 50.h),
                  ] else ...[
                    Text(
                      'Client name',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    AppTextField(
                      hintText: 'Client name',
                      controller: nameController,
                      enabled: viewModel.isEditing,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'Client phone number',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    AppTextField(
                      hintText: 'Client phone number',
                      controller: phoneNumberController,
                      enabled: false,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'Client address',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    AppTextField(
                      hintText: 'Client address',
                      controller: addressController,
                      enabled: false,
                    ),
                  ],
                  SizedBox(
                    height: 32.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppButton(
                        buttonText: viewModel.isEditing
                            ? 'Save'
                            : 'Update client details',
                        onPressed: () {
                          if (!viewModel.isEditing) {
                            viewModel.toggleEditing();
                          } else if (hasChanges()) {
                            if (businessId != null) {
                              viewModel.updateClient(
                                  businessId: businessId,
                                  clientId: clientId,
                                  newName: nameController.text,
                                  navigateOnSuccess: () {
                                    locator<PayvidenceAppRouter>().back();
                                  });
                            } else {
                              print(
                                  "Business ID is null, cannot update client");
                            }
                          } else {
                            print("No changes detected, exiting edit mode");
                            viewModel.toggleEditing();
                          }
                        },
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      AppButton(
                        backgroundColor: Colors.transparent,
                        buttonText: 'Remove client',
                        textColor: appRed,
                        onPressed: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              clipBehavior: Clip.none,
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 398.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(40.r),
                                          topLeft: Radius.circular(40.r))),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 10.h),
                                    child: Stack(
                                      children: [
                                        ListView(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 140.w),
                                              child: Container(
                                                height: 5.h,
                                                width: 67.w,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffd9d9d9),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100.r),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 38.h,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const SizedBox.shrink(),
                                                Center(
                                                  child: Text(
                                                    'Confirm remove',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayLarge!
                                                        .copyWith(
                                                          fontSize: 22.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                    onTap: () => locator<
                                                            PayvidenceAppRouter>()
                                                        .back(),
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
                                                'Are you sure you want to remove this client? \n\nAll saved details will be gone.',
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 47.h,
                                            ),
                                            AppButton(
                                              buttonText: 'Remove client',
                                              onPressed: () async {
                                                await viewModel.removeClient(
                                                    businessId: businessId,
                                                    clientId: clientId,
                                                    navigateOnSuccess: () {
                                                      locator<PayvidenceAppRouter>()
                                                          .back();
                                                    });
                                              },
                                              backgroundColor: appRed,
                                              textColor: Colors.white,
                                            ),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            AppButton(
                                              buttonText: 'Cancel',
                                              onPressed: () {},
                                              backgroundColor:
                                                  Colors.transparent,
                                              textColor: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                          // context.push(AppRoutes.generateReceipt);
                        },
                      ),
                      // Text('Remove client', style: Theme.of(context).textTheme.displayMedium!.copyWith(color: primaryColor2),),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
