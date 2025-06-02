import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/screens/forgot_password/forgot_password_vm.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'ForgotPasswordRoute')
class ForgotPassword extends HookConsumerWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final viewModel = ref.watch(forgotPasswordViewModelProvider);
    final emailController = useTextEditingController();
    final isTextFieldEmpty = useState(true);
    final isEmailValid = useState(false);
    final responsiveData = ResponsiveInherited.of(context);

    bool checkEmailValid(String email) {
      return email.trim().isValidEmail;
    }

    useEffect(() {
      void updateFieldStatus() {
        isTextFieldEmpty.value = emailController.text.trim().isEmpty;
        isEmailValid.value = checkEmailValid(emailController.text);
        print("Field empty: ${isTextFieldEmpty.value}, Email valid: ${isEmailValid.value}");
      }

      emailController.addListener(updateFieldStatus);
      return () => emailController.removeListener(updateFieldStatus);
    }, []);

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: responsiveData.scaleHeight(16)),
                  Text(
                    'Recover account',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(height: responsiveData.scaleHeight(8)),
                  Text(
                    'Enter email address used for registration.',
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
                  SizedBox(height: responsiveData.scaleHeight(32)),
                  AppButton(
                    isDisabled: isTextFieldEmpty.value || !isEmailValid.value,
                    isProcessing: viewModel.isLoading,
                    buttonText: 'Continue',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        print("Form is valid");
                        FocusScope.of(context).unfocus();
                        viewModel.forgotPasswordInit(
                          email: emailController.text.trim(),
                          navigateOnSuccess: () {
                            print('navigating');
                            locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.otpLogin);
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
    );
  }
}