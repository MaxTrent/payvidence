import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
import 'package:payvidence/screens/update_personal_details/update_personal_details_vm.dart';
import 'package:payvidence/utilities/validators.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'UpdatePersonalDetailsRoute')
class UpdatePersonalDetails extends HookConsumerWidget {
  const UpdatePersonalDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(updatePersonalDetailsViewModelProvider);
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();
    final originalFirstName = useState("");
    final originalLastName = useState("");
    final originalPhoneNumber = useState("");
    final firstNameFocusNode = useFocusNode();
    final lastNameFocusNode = useFocusNode();
    final phoneFocusNode = useFocusNode();
    final responsiveData = ResponsiveInherited.of(context);

    useEffect(() {
      viewModel.fetchUserInformation();
      return null;
    }, []);

    useEffect(() {
      if (viewModel.userInfo != null && !viewModel.isLoading) {
        firstNameController.text = viewModel.userInfo?.account.firstName ?? "";
        lastNameController.text = viewModel.userInfo?.account.lastName ?? "";
        emailController.text = viewModel.userInfo?.account.email ?? "";
        phoneController.text = viewModel.userInfo?.account.phoneNumber ?? "";
        originalFirstName.value = viewModel.userInfo?.account.firstName ?? "";
        originalLastName.value = viewModel.userInfo?.account.lastName ?? "";
        originalPhoneNumber.value = viewModel.userInfo?.account.phoneNumber ?? "";
      }
      return null;
    }, [viewModel.userInfo, viewModel.isLoading]);

    bool hasChanges() {
      return firstNameController.text != originalFirstName.value ||
          lastNameController.text != originalLastName.value ||
          phoneController.text != originalPhoneNumber.value;
    }

    return ResponsiveWrapper(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: KeyboardDismissibleScaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
            child: SafeArea(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: responsiveData.scaleHeight(16)),
                    Text(
                      'Update personal details',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    SizedBox(height: responsiveData.scaleHeight(8)),
                    Text(
                      'You can update your profile here.',
                      style: Theme.of(context).textTheme.displaySmall!,
                    ),
                    SizedBox(height: responsiveData.scaleHeight(32)),
                    if (viewModel.isLoading) ...[
                      Text('First name',
                          style: Theme.of(context).textTheme.displaySmall),
                      SizedBox(height: responsiveData.scaleHeight(8)),
                      CustomShimmer(height: responsiveData.scaleHeight(50)),
                      SizedBox(height: responsiveData.scaleHeight(20)),
                      Text('Last name',
                          style: Theme.of(context).textTheme.displaySmall),
                      SizedBox(height: responsiveData.scaleHeight(8)),
                      CustomShimmer(height: responsiveData.scaleHeight(50)),
                      SizedBox(height: responsiveData.scaleHeight(20)),
                      Text('Email address',
                          style: Theme.of(context).textTheme.displaySmall),
                      SizedBox(height: responsiveData.scaleHeight(8)),
                      CustomShimmer(height: responsiveData.scaleHeight(50)),
                      SizedBox(height: responsiveData.scaleHeight(20)),
                      Text('Phone number',
                          style: Theme.of(context).textTheme.displaySmall),
                      SizedBox(height: responsiveData.scaleHeight(8)),
                      CustomShimmer(height: responsiveData.scaleHeight(50)),
                    ] else ...[
                      Text('First name',
                          style: Theme.of(context).textTheme.displaySmall),
                      SizedBox(height: responsiveData.scaleHeight(8)),
                      AppTextField(
                        hintText: 'First name',
                        enabled: viewModel.isEditing,
                        controller: firstNameController,
                        keyboardType: TextInputType.name,
                        focusNode: firstNameFocusNode,
                        textCapitalization: TextCapitalization.words,
                        validator: (val) {
                          if (!val!.trim().isValidName || val.isEmpty) {
                            return 'Enter a valid name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: responsiveData.scaleHeight(20)),
                      Text('Last name',
                          style: Theme.of(context).textTheme.displaySmall),
                      SizedBox(height: responsiveData.scaleHeight(8)),
                      AppTextField(
                        hintText: 'Last name',
                        enabled: viewModel.isEditing,
                        controller: lastNameController,
                        keyboardType: TextInputType.name,
                        focusNode: lastNameFocusNode,
                        textCapitalization: TextCapitalization.words,
                        validator: (val) {
                          if (!val!.trim().isValidName || val.isEmpty) {
                            return 'Enter a valid name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: responsiveData.scaleHeight(20)),
                      Text('Email address',
                          style: Theme.of(context).textTheme.displaySmall),
                      SizedBox(height: responsiveData.scaleHeight(8)),
                      AppTextField(
                        hintText: 'Email address',
                        enabled: false,
                        controller: emailController,
                      ),
                      SizedBox(height: responsiveData.scaleHeight(20)),
                      Text('Phone number',
                          style: Theme.of(context).textTheme.displaySmall),
                      SizedBox(height: responsiveData.scaleHeight(8)),
                      AppTextField(
                        hintText: 'Phone number',
                        enabled: viewModel.isEditing,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        focusNode: phoneFocusNode,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(11),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (val) {
                          if (val!.trim().isEmpty || !val.isValidPhone) {
                            return 'Enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                    ],
                    SizedBox(height: responsiveData.scaleHeight(32)),
                    AppButton(
                      isProcessing: viewModel.isLoading,
                      buttonText: viewModel.isEditing ? 'Save' : 'Update details',
                      isDisabled: viewModel.isEditing && !hasChanges(),
                      onPressed: () {
                        if (viewModel.isEditing) {
                          if (formKey.currentState!.validate() && hasChanges()) {
                            viewModel.updateUserInfo(
                              newFirstName: firstNameController.text,
                              newLastName: lastNameController.text,
                              newPhoneNumber: phoneController.text != originalPhoneNumber.value 
                                  ? phoneController.text 
                                  : null,
                              navigateOnSuccess: () {
                                // Update original values to reflect saved state
                                originalFirstName.value = firstNameController.text;
                                originalLastName.value = lastNameController.text;
                                originalPhoneNumber.value = phoneController.text;
                              },
                            );
                          }
                        } else {
                          viewModel.toggleEditing();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}