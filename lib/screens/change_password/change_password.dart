import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
import 'package:payvidence/screens/change_password/change_password_vm.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/responsive_wrapper.dart';
import '../onboarding/onboarding.dart';

@RoutePage(name: 'ChangePasswordRoute')
class ChangePassword extends HookConsumerWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final viewModel = ref.watch(changePasswordViewModel);
    final passwordController = useTextEditingController();
    final newPasswordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final areFieldsEmpty = useState(true);
    final responsiveData = ResponsiveInherited.of(context);

    bool checkFieldsEmpty() {
      return passwordController.text.toString().isEmpty ||
          newPasswordController.text.toString().isEmpty ||
          confirmPasswordController.text.toString().isEmpty;
    }

    useEffect(() {
      void updateFieldsEmptyStatus() {
        final isEmpty = checkFieldsEmpty();
        if (areFieldsEmpty.value != isEmpty) {
          areFieldsEmpty.value = isEmpty;
        }
        print("Fields empty: ${areFieldsEmpty.value}");
      }

      passwordController.addListener(updateFieldsEmptyStatus);
      newPasswordController.addListener(updateFieldsEmptyStatus);
      confirmPasswordController.addListener(updateFieldsEmptyStatus);

      return () {
        passwordController.removeListener(updateFieldsEmptyStatus);
        newPasswordController.removeListener(updateFieldsEmptyStatus);
        confirmPasswordController.removeListener(updateFieldsEmptyStatus);
      };
    }, []);

    return ResponsiveWrapper(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
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
                    SizedBox(
                      height: responsiveData.scaleHeight(16),
                    ),
                    Text(
                      'Change your password',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    Text(
                      'Enter your previous password and set new one.',
                      style: Theme.of(context).textTheme.displaySmall!,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(32),
                    ),
                    Text(
                      'Current password',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    AppTextField(
                      hintText: 'Current password',
                      controller: passwordController,
                      validator: (val) {
                        if (!val!.trim().isValidPassword || val.isEmpty) {
                          return 'Enter a valid password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(20),
                    ),
                    Text(
                      'New password',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    AppTextField(
                      hintText: 'New password',
                      controller: newPasswordController,
                      validator: (val) {
                        if (!val!.trim().isValidPassword || val.isEmpty) {
                          return 'Enter a valid password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(20),
                    ),
                    Text(
                      'Confirm new password',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    AppTextField(
                      hintText: 'Re-enter new password',
                      controller: confirmPasswordController,
                      validator: (val) {
                        final password = newPasswordController.text;
                        if (!val!.trim().isValidPassword || val.isEmpty) {
                          return 'Enter a valid password';
                        }
                        if (val != password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(32),
                    ),
                    AppButton(
                      isProcessing: viewModel.isLoading,
                      isDisabled: areFieldsEmpty.value,
                      buttonText: 'Change password',
                      onPressed: () {
                        print("Button pressed");
                        if (formKey.currentState!.validate()) {
                          print("Form is valid");
                          FocusScope.of(context).unfocus();
                          viewModel.changePassword(
                              oldPassword: passwordController.text.trim(),
                              newPassword: newPasswordController.text.trim(),
                              confirmNewPassword: newPasswordController.text.trim(),
                              navigateOnSuccess: () {
                                locator<PayvidenceAppRouter>().popUntil(
                                        (route) => route is OnboardingScreen);
                                locator<PayvidenceAppRouter>().navigateNamed(
                                    PayvidenceRoutes.changePasswordSuccess);
                              });
                        } else {
                          print("Form is not valid");
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