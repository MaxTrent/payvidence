import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/providers/business_providers/get_all_business_provider.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/login/login_vm.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/keyboard_dismissible_scaffold.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../utilities/theme_mode.dart';
import '../onboarding/onboarding.dart';

@RoutePage(name: 'LoginRoute')
class Login extends HookConsumerWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final viewModel = ref.watch(loginViewModelProvider);
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final responsiveData = ResponsiveInherited.of(context);

    final areFieldsEmpty = useState(true);
    final isEmailValid = useState(false);
    final obscureText = useState(true);
    final showManualLogin = useState(false);




    bool checkFieldsEmpty() {
      return emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty;
    }

    bool checkEmailValid(String email) {
      return email.trim().isValidEmail;
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadSavedEmail().then((savedEmail) {
          if (savedEmail != null && savedEmail.isNotEmpty) {
            emailController.text = savedEmail;
            isEmailValid.value = checkEmailValid(savedEmail);
            areFieldsEmpty.value = checkFieldsEmpty();
          }
        });
      });
      return null;
    }, []);

    useEffect(() {
      void updateFieldsStatus() {
        final isEmpty = checkFieldsEmpty();
        final emailValid = checkEmailValid(emailController.text);
        if (areFieldsEmpty.value != isEmpty) {
          areFieldsEmpty.value = isEmpty;
        }
        if (isEmailValid.value != emailValid) {
          isEmailValid.value = emailValid;
        }
        print("Fields empty: ${areFieldsEmpty.value}, Email valid: ${isEmailValid.value}");
      }

      emailController.addListener(updateFieldsStatus);
      passwordController.addListener(updateFieldsStatus);

      return () {
        emailController.removeListener(updateFieldsStatus);
        passwordController.removeListener(updateFieldsStatus);
      };
    }, []);

    final useBiometricLogin = viewModel.shouldUseBiometricLogin && !showManualLogin.value;

    return ResponsiveWrapper(
      child: PopScope(
        onPopInvoked: (didPop) {
          if (viewModel.isLoading) {
            viewModel.cancelOperation();
          }
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: KeyboardDismissibleScaffold(
          appBar: AppBar(),
          body: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: responsiveData.scaleHeight(16)),
                      Text(
                        'Log in',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(height: responsiveData.scaleHeight(8)),
                      Text(
                        useBiometricLogin
                            ? 'Log in with your biometric credentials'
                            : 'Log in with your email address and password',
                        style: Theme.of(context).textTheme.displaySmall!,
                      ),
                      SizedBox(height: responsiveData.scaleHeight(32)),
                      if (!useBiometricLogin) ...[
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
                        SizedBox(height: responsiveData.scaleHeight(20)),
                        Text(
                          'Password',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        SizedBox(height: responsiveData.scaleHeight(8)),
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
                            padding: EdgeInsets.all(responsiveData.scaleHeight(16)),
                            child: GestureDetector(
                              onTap: () => obscureText.value = !obscureText.value,
                              child: SvgPicture.asset(
                                Assets.svg.password,
                                height: responsiveData.scaleHeight(24),
                                width: responsiveData.scaleWidth(24),
                                colorFilter: ColorFilter.mode(
                                  isDarkMode ? Colors.white : Colors.black,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          obscureText: obscureText.value,
                        ),
                        SizedBox(height: responsiveData.scaleHeight(20)),
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
                                .copyWith(
                              fontSize: Responsive.fontSize(context, 14),
                              color: primaryColor2,
                            ),
                          ),
                        ),
                        SizedBox(height: responsiveData.scaleHeight(32)),
                      ],
                      useBiometricLogin
                          ? Center(
                        child: Image.asset(
                          Assets.png.faceId.path,
                          color: isDarkMode ? Colors.white : Colors.black,
                          height: responsiveData.scaleHeight(200),
                        ),
                      )
                          : const SizedBox.shrink(),
                      SizedBox(height: responsiveData.scaleHeight(32)),
                      if (useBiometricLogin && viewModel.errorMessage.isNotEmpty) ...[
                        GestureDetector(
                          onTap: () {
                            showManualLogin.value = true;
                          },
                          child: Text(
                            'Log in with email/password',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                              fontSize: Responsive.fontSize(context, 14),
                              color: primaryColor2,
                            ),
                          ),
                        ),
                        SizedBox(height: responsiveData.scaleHeight(32)),
                      ],
                      AppButton(
                        buttonText: 'Log in',
                        isDisabled: useBiometricLogin
                            ? false
                            : (areFieldsEmpty.value || !isEmailValid.value),
                        isProcessing: viewModel.isLoading,
                        onPressed: () {
                          print("Login button pressed");
                          FocusScope.of(context).unfocus();
                          if (useBiometricLogin) {
                            print("Using biometric login");
                            viewModel.biometricLogin(
                              navigateOnSuccess: () {
                                print("Biometric login successful, navigating to home");
                                ref.invalidate(getAllBusinessProvider);
                                locator<PayvidenceAppRouter>().popUntil(
                                        (route) => route is OnboardingScreen);
                                locator<PayvidenceAppRouter>()
                                    .navigateNamed(PayvidenceRoutes.home);
                                print('navigating back');
                              },
                            );
                          } else {
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
                                  locator<PayvidenceAppRouter>()
                                      .navigateNamed(PayvidenceRoutes.home);
                                  print('navigating back');
                                },
                                navigateToOtp: () {
                                  print("Halfway signup detected, navigating to OTP");
                                  locator<PayvidenceAppRouter>()
                                      .navigateNamed(PayvidenceRoutes.otp);
                                },
                              );
                            } else {
                              print("Form validation failed");
                            }
                          }
                        },
                      ),
                      SizedBox(height: responsiveData.scaleHeight(16)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}