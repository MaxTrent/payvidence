import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/screens/client_details/client_details_vm.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../constants/app_colors.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/responsive.dart';
import '../../utilities/responsive_wrapper.dart';

@RoutePage(name: 'ClientDetailsRoute')
class ClientDetails extends HookConsumerWidget {
  final String clientId;
  final String businessId;

  const ClientDetails({
    super.key,
    @PathParam('businessId') this.businessId = '',
    @PathParam('clientId') this.clientId = '',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(clientDetailsViewModelViewModelProvider);
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final nameController = useTextEditingController();
    final phoneNumberController = useTextEditingController();
    final addressController = useTextEditingController();
    final originalName = useState("");
    final originalPhoneNumber = useState("");
    final originalAddress = useState("");
    final nameFocusNode = useFocusNode();
    final responsiveData = ResponsiveInherited.of(context);

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
        originalPhoneNumber.value = viewModel.clientInfo?.phoneNumber ?? '';
        originalAddress.value = viewModel.clientInfo?.address ?? '';
        print("Controllers set with clientInfo: ${viewModel.clientInfo!.name}");
      }
      return null;
    }, [viewModel.clientInfo, viewModel.isLoading]);

    bool hasChanges() {
      return nameController.text != originalName.value ||
             phoneNumberController.text != originalPhoneNumber.value ||
             addressController.text != originalAddress.value;
    }

    Future<bool> onWillPop() async {
      if (viewModel.isEditing && hasChanges()) {
        viewModel.updateClient(
          businessId: businessId,
          clientId: clientId,
          newName: nameController.text,
          newPhoneNumber: phoneNumberController.text,
          newAddress: addressController.text,
          navigateOnSuccess: () {
            locator<PayvidenceAppRouter>().back();
          },
        );
        return false;
      }
      return true;
    }

    return ResponsiveWrapper(
      child: PopScope(
        canPop: !viewModel.isEditing || !hasChanges(),
        onPopInvoked: (didPop) async {
          if (!didPop && viewModel.isEditing && hasChanges()) {
            await onWillPop();
          }
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
              child: SafeArea(
                child: Form(
                  key: formKey,
                  child: ListView(
                    children: [
                      SizedBox(height: responsiveData.scaleHeight(16)),
                      Text(
                        'Client details',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(height: responsiveData.scaleHeight(8)),
                      Text(
                        'You can update or remove client details.',
                        style: Theme.of(context).textTheme.displaySmall!,
                      ),
                      SizedBox(height: responsiveData.scaleHeight(32)),
                      if (viewModel.isLoading) ...[
                        Text(
                          'Client name',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        SizedBox(height: responsiveData.scaleHeight(8)),
                        CustomShimmer(height: responsiveData.scaleHeight(50)),
                        SizedBox(height: responsiveData.scaleHeight(20)),
                        Text(
                          'Client phone number',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        SizedBox(height: responsiveData.scaleHeight(8)),
                        CustomShimmer(height: responsiveData.scaleHeight(50)),
                        SizedBox(height: responsiveData.scaleHeight(20)),
                        Text(
                          'Client address',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        SizedBox(height: responsiveData.scaleHeight(8)),
                        CustomShimmer(height: responsiveData.scaleHeight(50)),
                      ] else ...[
                        Text(
                          'Client name',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        SizedBox(height: responsiveData.scaleHeight(8)),
                        AppTextField(
                          hintText: 'Client name',
                          controller: nameController,
                          enabled: viewModel.isEditing,
                          focusNode: nameFocusNode,
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                        ),
                        SizedBox(height: responsiveData.scaleHeight(20)),
                        Text(
                          'Client phone number',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        SizedBox(height: responsiveData.scaleHeight(8)),
                        AppTextField(
                          hintText: 'Client phone number',
                          controller: phoneNumberController,
                          enabled: viewModel.isEditing,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(11),
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (val) {
                            if (val != null && val.isNotEmpty && !val.trim().isValidPhone) {
                              return 'Enter a valid Nigerian phone number (11 digits starting with 070, 080, 081, 090, etc.)';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: responsiveData.scaleHeight(20)),
                        Text(
                          'Client address',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        SizedBox(height: responsiveData.scaleHeight(8)),
                        AppTextField(
                          hintText: 'Client address',
                          controller: addressController,
                          enabled: viewModel.isEditing,
                          textCapitalization: TextCapitalization.words,
                        ),
                      ],
                      SizedBox(height: responsiveData.scaleHeight(32)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppButton(
                            isProcessing: viewModel.isLoading,
                            buttonText: viewModel.isEditing
                                ? 'Save'
                                : 'Update client details',
                            onPressed: () {
                              if (!viewModel.isEditing) {
                                viewModel.toggleEditing();
                                nameFocusNode.requestFocus();
                              } else if (hasChanges()) {
                                viewModel.updateClient(
                                  businessId: businessId,
                                  clientId: clientId,
                                  newName: nameController.text,
                                  newPhoneNumber: phoneNumberController.text,
                                  newAddress: addressController.text,
                                  navigateOnSuccess: () {
                                    locator<PayvidenceAppRouter>().back();
                                  },
                                );
                              } else {
                                print("No changes detected, exiting edit mode");
                                viewModel.toggleEditing();
                              }
                            },
                          ),
                          SizedBox(height: responsiveData.scaleHeight(8)),
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
                                    height: responsiveData.scaleHeight(398),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
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
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: responsiveData.scaleWidth(140)),
                                                child: Container(
                                                  height: responsiveData.scaleHeight(5),
                                                  width: responsiveData.scaleWidth(67),
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xffd9d9d9),
                                                    borderRadius:
                                                    BorderRadius.circular(responsiveData.largeRadius),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: responsiveData.scaleHeight(38)),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                                children: [
                                                  const SizedBox.shrink(),
                                                  Center(
                                                    child: Text(
                                                      'Confirm remove',
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
                                                    onTap: () =>
                                  Navigator.pop(context),
                                                    child: const Icon(Icons.close),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: responsiveData.scaleHeight(12)),
                                              Center(
                                                child: Text(
                                                  'Are you sure you want to remove this client? \n\nAll saved details will be gone.',
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context).textTheme.displaySmall,
                                                ),
                                              ),
                                              SizedBox(height: responsiveData.scaleHeight(47)),
                                              AppButton(
                                                buttonText: 'Remove client',
                                                onPressed: () async {
                                                  await viewModel.removeClient(
                                                    businessId: businessId,
                                                    clientId: clientId,
                                                    navigateOnSuccess: () {
                                                      locator<PayvidenceAppRouter>().back();
                                                    },
                                                  );
                                                },
                                                backgroundColor: appRed,
                                                textColor: Colors.white,
                                              ),
                                              SizedBox(height: responsiveData.scaleHeight(8)),
                                              AppButton(
                                                buttonText: 'Cancel',
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                backgroundColor: Colors.transparent,
                                                textColor: Colors.black,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}