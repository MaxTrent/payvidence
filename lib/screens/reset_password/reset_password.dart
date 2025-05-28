import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/screens/reset_password/reset_password_vm.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/responsive_wrapper.dart';
import '../onboarding/onboarding.dart';

@RoutePage(name: 'ResetPasswordRoute')
class ResetPassword extends HookConsumerWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final viewModel = ref.watch(resetPasswordViewModelProvider);
    final emailController = useTextEditingController();
    final isTextFieldEmpty = useState(true);
    final isEmailValid = useState(false);
    final isLoading = useState(false); // Track loading state
    final errorMessage = useState<String?>(null); // Track error messages
    final responsiveData = ResponsiveInherited.of(context);

    // Check email validity
    bool checkEmailValid(String email) {
      return email.trim().isValidEmail;
    }

    // Effect to monitor email input changes
    useEffect(() {
      void updateFieldStatus() {
        final email = emailController.text.trim();
        isTextFieldEmpty.value = email.isEmpty;
        isEmailValid.value = checkEmailValid(email);
        errorMessage.value = null; // Clear error when typing
        print("Field empty: ${isTextFieldEmpty.value}, Email valid: ${isEmailValid.value}");
      }

      emailController.addListener(updateFieldStatus);
      return () => emailController.removeListener(updateFieldStatus);
    }, [emailController]);

    // Handle form submission
    void onSubmit() async {
      if (formKey.currentState!.validate()) {
        isLoading.value = true;
        FocusScope.of(context).unfocus();
        try {
          await viewModel.resetPasswordInit(
            email: emailController.text.trim(),
            navigateOnSuccess: () {
              locator<PayvidenceAppRouter>()
                  .popUntil((route) => route is OnboardingScreen);
              locator<PayvidenceAppRouter>()
                  .navigateNamed(PayvidenceRoutes.otpReset);
            },
          );
        } catch (e) {
          errorMessage.value = 'Failed to reset password. Please try again.';
          print("Error: $e");
        } finally {
          isLoading.value = false;
        }
      }
    }

    return ResponsiveWrapper(
        child: Scaffold(
        appBar: AppBar(
    ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal:responsiveData.paddingHorizontal),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
    SizedBox(height: responsiveData.scaleHeight(32)),
                Text(
                  'Reset password',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
    SizedBox(height: responsiveData.scaleHeight(16)),
                Text(
                  'Confirm email address used for registration.',
                  style: Theme.of(context).textTheme.displaySmall!,
                ),
    SizedBox(height: responsiveData.scaleHeight(32)),
                Text(
                  'Email address',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
    SizedBox(height: responsiveData.scaleHeight(8)),
                AppTextField(
                  hintText: 'Email address',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  autofillHints: const [AutofillHints.email],
                  validator: (val) {
                    if (!val!.trim().isValidEmail || val.isEmpty) {
                      return 'Enter valid email address';
                    }
                    return null;
                  },
                ),
    const Spacer(),
                AppButton(
                  isDisabled: isTextFieldEmpty.value || !isEmailValid.value,
                  isProcessing: viewModel.isLoading,
                  buttonText: 'Continue',
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      print("Form is valid");


                      FocusScope.of(context).unfocus();
                      viewModel.resetPasswordInit(
                        email: emailController.text.trim(),
                        navigateOnSuccess: () {
                          print('navigating');
                          locator<PayvidenceAppRouter>()
                              .popUntil((route) => route is OnboardingScreen);
                          locator<PayvidenceAppRouter>()
                              .navigateNamed(PayvidenceRoutes.otpReset);
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
      )));
  }
}