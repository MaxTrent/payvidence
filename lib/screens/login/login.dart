import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/providers/business_providers/get_all_business_provider.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/login/login_vm.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../onboarding/onboarding.dart';

@RoutePage(name: 'LoginRoute')
class Login extends HookConsumerWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final viewModel = ref.watch(loginViewModelProvider);

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final areFieldsEmpty = useState(true);
    final obscureText = useState(true);
    final showManualLogin = useState(false);

    bool checkFieldsEmpty() {
      return emailController.text.toString().isEmpty ||
          passwordController.text.toString().isEmpty;
    }

    useEffect(() {
      void updateFieldsEmptyStatus() {
        areFieldsEmpty.value = checkFieldsEmpty();
        print("Fields empty: ${areFieldsEmpty.value}");
      }

      emailController.addListener(updateFieldsEmptyStatus);
      passwordController.addListener(updateFieldsEmptyStatus);

      return () {
        emailController.removeListener(updateFieldsEmptyStatus);
        passwordController.removeListener(updateFieldsEmptyStatus);
      };
    }, []);

    final useBiometricLogin = viewModel.shouldUseBiometricLogin && !showManualLogin.value;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Text(
                      'Log in',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      useBiometricLogin
                          ? 'Log in with your biometric credentials'
                          : 'Log in with your email address and password',
                      style: Theme.of(context).textTheme.displaySmall!,
                    ),
                    SizedBox(height: 32.h),

                    // Show email/password fields if not using biometric login
                    if (!useBiometricLogin) ...[
                      Text(
                        'Email address',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      SizedBox(height: 8.h),
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
                      SizedBox(height: 20.h),
                      Text(
                        'Password',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      SizedBox(height: 8.h),
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
                        suffixIcon: Padding(
                          padding: EdgeInsets.all(16.h),
                          child: GestureDetector(
                            onTap: () => obscureText.value = !obscureText.value,
                            child: SvgPicture.asset(
                              Assets.svg.password,
                              height: 24.h,
                              width: 24.w,
                            ),
                          ),
                        ),
                        obscureText: obscureText.value,
                      ),
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () {
                          locator<PayvidenceAppRouter>()
                              .navigateNamed(PayvidenceRoutes.forgotPassword);
                        },
                        child: Text(
                          'Forgot password?',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontSize: 14.sp, color: primaryColor2),
                        ),
                      ),
                      SizedBox(height: 32.h),
                    ],
                    // Display error message if present
                    if (viewModel.errorMessage.isNotEmpty) ...[
                      Text(
                        viewModel.errorMessage,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(color: Colors.red),
                      ),
                      SizedBox(height: 16.h),
                    ],
                    // Show link if biometric login failed
                    if (useBiometricLogin && viewModel.errorMessage.isNotEmpty) ...[
                      GestureDetector(
                        onTap: () {
                          showManualLogin.value = true; // Switch to email/password login
                        },
                        child: Text(
                          'Log in with email/password',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontSize: 14.sp, color: primaryColor2),
                        ),
                      ),
                      SizedBox(height: 32.h),
                    ],

                    AppButton(
                      buttonText: 'Log in',
                      isDisabled: !useBiometricLogin && areFieldsEmpty.value,
                      isProcessing: viewModel.isLoading,
                      onPressed: () {
                        print("Login button pressed");
                        FocusScope.of(context).unfocus();
                        if (useBiometricLogin) {
                          // Use biometric login
                          print("Using biometric login");
                          viewModel.biometricLogin(
                            navigateOnSuccess: () {
                              print("Biometric login successful, navigating to home");
                              ref.invalidate(getAllBusinessProvider);
                              locator<PayvidenceAppRouter>().popUntil(
                                      (route) => route is OnboardingScreen);
                              locator<PayvidenceAppRouter>().replaceNamed(PayvidenceRoutes.home);
                            },
                          );
                        } else {
                          // Use email/password login
                          if (formKey.currentState!.validate()) {
                            print("Form validation passed");
                            viewModel.login(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              navigateOnSuccess: () {
                                print("Email/password login successful, navigating to home");
                                ref.invalidate(getAllBusinessProvider);
                                locator<PayvidenceAppRouter>().popUntil(
                                        (route) => route is OnboardingScreen);
                                locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.home);
                              },
                            );
                          } else {
                            print("Form validation failed");
                          }
                        }
                      },
                    ),
                    SizedBox(height: 16.h), // Add some padding at the bottom
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