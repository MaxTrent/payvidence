import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/screens/create_new_password/create_new_password_vm.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../onboarding/onboarding.dart';

@RoutePage(name: 'CreateNewPasswordRoute')
class CreateNewPassword extends HookConsumerWidget {
  const CreateNewPassword({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(createNewPasswordViewModel);
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final areFieldsEmpty = useState(true);

    bool checkFieldsEmpty() {
      return passwordController.text.toString().isEmpty ||
          confirmPasswordController.text.toString().isEmpty;
    }

    useEffect(() {
      void updateFieldsEmptyStatus() {
        areFieldsEmpty.value = checkFieldsEmpty();
        print("Fields empty: ${areFieldsEmpty.value}");
      }

      passwordController.addListener(updateFieldsEmptyStatus);
      confirmPasswordController.addListener(updateFieldsEmptyStatus);

      return () {
        passwordController.removeListener(updateFieldsEmptyStatus);
        confirmPasswordController.removeListener(updateFieldsEmptyStatus);
      };
    }, []);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus,
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    'Create new password',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    'You can use the new password to log in later.',
                    style: Theme.of(context).textTheme.displaySmall!,
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Text(
                    'Password',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    hintText: 'Password',
                    controller: passwordController,
                    validator: (val) {
                      if (!val!.trim().isValidPassword || val.isEmpty) {
                        return 'Enter a valid password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Confirm password',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    hintText: 'Re-enter password',
                    controller: confirmPasswordController,
                    validator: (val) {
                      final password = passwordController.text;
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
                    height: 32.h,
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
                        viewModel.createNewPassword(
                            password: passwordController.text.trim(),
                            confirmPassword:
                                confirmPasswordController.text.trim(),
                            navigateOnSuccess: () {
                              locator<PayvidenceAppRouter>().popUntil(
                                  (route) => route is OnboardingScreen);
                              locator<PayvidenceAppRouter>().navigateNamed(
                                  PayvidenceRoutes.changePasswordSuccess);
                            });
                      } else {
                        print("Form is not valid");
                      }
                      // locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.changePasswordSuccess);
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
