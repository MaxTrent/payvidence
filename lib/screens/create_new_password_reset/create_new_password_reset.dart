import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../onboarding/onboarding.dart';
import 'create_new_password_reset_vm.dart';

@RoutePage(name: 'CreateNewPasswordResetRoute')
class CreateNewPasswordReset extends HookConsumerWidget {
  const CreateNewPasswordReset({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(createNewPasswordResetViewModel);
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final areFieldsEmpty = useState(true);
    final responsiveData = ResponsiveInherited.of(context);

    bool checkFieldsEmpty() {
      return passwordController.text.toString().isEmpty ||
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
      confirmPasswordController.addListener(updateFieldsEmptyStatus);

      return () {
        passwordController.removeListener(updateFieldsEmptyStatus);
        confirmPasswordController.removeListener(updateFieldsEmptyStatus);
      };
    }, []);

    return ResponsiveWrapper(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus,
        child: KeyboardDismissibleScaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(),
          body: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: responsiveData.scaleHeight(16),
                    ),
                    Text(
                      'Create new password',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    Text(
                      'You can use the new password to log in later.',
                      style: Theme.of(context).textTheme.displaySmall!,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(32),
                    ),
                    Text(
                      'Password',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    AppTextField(
                      hintText: 'Password',
                      controller: passwordController,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Password is required';
                        }
                        if (val.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        if (!RegExp(r'[A-Za-z]').hasMatch(val)) {
                          return 'Password must contain at least one letter';
                        }
                        if (!RegExp(r'\d').hasMatch(val)) {
                          return 'Password must contain at least one number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(20),
                    ),
                    Text(
                      'Confirm password',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    AppTextField(
                      hintText: 'Re-enter password',
                      controller: confirmPasswordController,
                      validator: (val) {
                        final password = passwordController.text.trim();

                        if (val == null || val.trim().isEmpty) {
                          return 'Please confirm your password';
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
                      buttonText: 'Save new password',
                      onPressed: () {
                        print("Button pressed");
                        if (formKey.currentState!.validate()) {
                          print("Form is valid");
                          FocusScope.of(context).unfocus();
                          viewModel.resetPassword(
                            password: passwordController.text.trim(),
                            confirmPassword: confirmPasswordController.text.trim(),
                            navigateOnSuccess: () {
                              locator<PayvidenceAppRouter>().popUntil(
                                      (route) => route is OnboardingScreen);
                              locator<PayvidenceAppRouter>().navigateNamed(
                                  PayvidenceRoutes.resetPasswordSuccess);
                            },
                          );
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