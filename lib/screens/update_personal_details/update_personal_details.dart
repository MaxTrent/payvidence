import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/screens/update_personal_details/update_personal_details_vm.dart';
import 'package:payvidence/utilities/validators.dart';
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
        originalLastName.value = viewModel.userInfo?.account.lastName ?? ""; // Set original last name
        originalPhoneNumber.value = viewModel.userInfo?.account.phoneNumber ?? ""; // Set original phone number
        }
      return null;
    }, [viewModel.userInfo, viewModel.isLoading]);


    bool hasChanges() {
      return firstNameController.text != originalFirstName.value ||
          lastNameController.text != originalLastName.value ||
          phoneController.text != originalPhoneNumber.value;
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  Text(
                    'Update personal details',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'You can update your profile here.',
                    style: Theme.of(context).textTheme.displaySmall!,
                  ),
                  SizedBox(height: 32.h),
                  if (viewModel.isLoading) ...[
                    Text('First name',
                        style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(height: 8.h),
                    CustomShimmer(height: 50.h),
                    SizedBox(height: 20.h),
                    Text('Last name',
                        style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(height: 8.h),
                    CustomShimmer(height: 50.h),
                    SizedBox(height: 20.h),
                    Text('Email address',
                        style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(height: 8.h),
                    CustomShimmer(height: 50.h),
                    SizedBox(height: 20.h),
                    Text('Phone number',
                        style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(height: 8.h),
                    CustomShimmer(height: 50.h),
                  ] else ...[
                    Text('First name',
                        style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(height: 8.h),
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
                    SizedBox(height: 20.h),
                    Text('Last name',
                        style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(height: 8.h),
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
                    SizedBox(height: 20.h),
                    Text('Email address',
                        style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(height: 8.h),
                    AppTextField(
                      hintText: 'Email address',
                      enabled: false, // Email remains disabled
                      controller: emailController,
                    ),
                    SizedBox(height: 20.h),
                    Text('Phone number',
                        style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(height: 8.h),
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
                  SizedBox(height: 32.h),
                  AppButton(
                    isProcessing: viewModel.isLoading,
                    buttonText: viewModel.isEditing ? 'Save' : 'Update details',
                    // isDisabled: viewModel.isEditing && !hasChanges(),
                    onPressed: () {
                      if (!viewModel.isEditing) {
                        viewModel.toggleEditing();
                        firstNameFocusNode.requestFocus();
                      } else if (hasChanges()) {
                        if (formKey.currentState!.validate()) {
                          viewModel.updateUserInfo(
                            newFirstName: firstNameController.text.trim(),
                            newLastName: lastNameController.text.trim(),
                            newPhoneNumber: phoneController.text.trim(),
                            navigateOnSuccess: () {
                              locator<PayvidenceAppRouter>().back();
                            },
                          );
                        }
                      } else {
                        print("No changes detected, exiting edit mode");
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
    );
  }
}