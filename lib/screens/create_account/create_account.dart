import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/create_account/create_account_vm.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_text_field.dart';
import '../../gen/assets.gen.dart';
import '../../utilities/theme_mode.dart';
import '../onboarding/onboarding.dart';

@RoutePage(name: 'CreateAccountRoute')
class CreateAccountScreen extends HookConsumerWidget {
  const CreateAccountScreen({super.key});

  final _formKey = const GlobalObjectKey<FormState>('form');

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(createAccountViewModelProvider);
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;

    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordConfirmController = useTextEditingController();

    final _areFieldsEmpty = useState(true);
    final obscurePasswordText = useState(true);
    final obscurePasswordConfirmText = useState(true);

    bool areFieldsEmpty() {
      return firstNameController.text.toString().isEmpty ||
          lastNameController.text.toString().isEmpty ||
          phoneController.text.toString().isEmpty ||
          emailController.text.toString().isEmpty ||
          passwordController.text.toString().isEmpty ||
          passwordConfirmController.text.toString().isEmpty;
    }

    useEffect(() {
      void updateFieldsEmptyStatus() {
        _areFieldsEmpty.value = areFieldsEmpty();
      }

      firstNameController.addListener(updateFieldsEmptyStatus);
      lastNameController.addListener(updateFieldsEmptyStatus);
      emailController.addListener(updateFieldsEmptyStatus);
      phoneController.addListener(updateFieldsEmptyStatus);
      passwordController.addListener(updateFieldsEmptyStatus);
      passwordConfirmController.addListener(updateFieldsEmptyStatus);

      return () {
        firstNameController.removeListener(updateFieldsEmptyStatus);
        lastNameController.removeListener(updateFieldsEmptyStatus);
        emailController.removeListener(updateFieldsEmptyStatus);
        phoneController.removeListener(updateFieldsEmptyStatus);
        passwordController.removeListener(updateFieldsEmptyStatus);
        passwordConfirmController.removeListener(updateFieldsEmptyStatus);
      };
    }, [
      firstNameController,
      lastNameController,
      emailController,
      phoneController,
      passwordController,
      passwordConfirmController,
    ]);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SafeArea(
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    'Enter your details',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    'Create an account to enjoy Payvidence.',
                    style: Theme.of(context).textTheme.displaySmall!,
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Text(
                    'First name',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    hintText: 'First Name',
                    controller: firstNameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    // ref.watch(
                    //     CreateAccountViewModel.firstNameControllerProvider),
                    validator: (val) {

                      if (!val!.trim().isValidName || val.isEmpty) {
                        return 'Enter a valid name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Last name',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    hintText: 'Last Name',
                    controller: lastNameController,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    validator: (val) {
                      if (!val!.trim().isValidName || val.trim().isEmpty) {
                        return 'Enter a valid password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Email address',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
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
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Phone number',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    hintText: 'Phone number',
                    keyboardType: TextInputType.number,
                    controller: phoneController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (val) {
                      if (!val!.trim().isValidPhone || val.isEmpty) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Password',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    hintText: 'Password (8+ characters)',
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
                    controller: passwordController,
                    obscureText: obscurePasswordText.value,
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(16.h),
                      child: GestureDetector(
                          onTap: () => obscurePasswordText.value =
                              !obscurePasswordText.value,
                          child: SvgPicture.asset(Assets.svg.password, colorFilter: ColorFilter.mode(isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn),)),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Confirm Password',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    hintText: 'Confirm Password',
                    controller: passwordConfirmController,
                    obscureText: obscurePasswordConfirmText.value,
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
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(16.h),
                      child: GestureDetector(
                          onTap: () => obscurePasswordConfirmText.value =
                              !obscurePasswordConfirmText.value,
                          child: SvgPicture.asset(Assets.svg.password,  colorFilter: ColorFilter.mode(isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn),)),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text.rich(TextSpan(
                      text: 'By continuing, you agree to Payvidence\'s ',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: 14.sp),
                      children: [
                        TextSpan(
                            text: 'Terms & Conditions',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700)),
                        const TextSpan(text: ' and '),
                        TextSpan(
                            text: 'Privacy Policy',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700)),
                      ])),
                  SizedBox(
                    height: 32.h,
                  ),
                  // viewModel.createAccountState.isLoading
                  //     ? const LoadingIndicator()
                  //     :
                  AppButton(
                    buttonText: 'Create account',
                    isDisabled: _areFieldsEmpty.value,
                    isProcessing: viewModel.isLoading,
                    onPressed: () {
                      debugPrint("Button pressed");
                      if (_formKey.currentState!.validate()) {
                        debugPrint("Form is valid");
                        FocusScope.of(context).unfocus();
                        viewModel.createAccount(
                            firstName: firstNameController.text.trim(),
                            lastName: lastNameController.text.trim(),
                            phone: phoneController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            passwordConfirm:
                                passwordConfirmController.text.trim(),
                            navigateOnSuccess: () {
                              // locator<PayvidenceAppRouter>().popUntil(
                              //     (route) => route is OnboardingScreen);
                              locator<PayvidenceAppRouter>()
                                  .navigateNamed(PayvidenceRoutes.otp);
                            });
                      } else {
                        print("Form is not valid");
                      }
                    },
                  ),
                  SizedBox(
                    height: 36.h,
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
