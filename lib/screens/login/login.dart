import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/login/login_vm.dart';
import 'package:payvidence/screens/onboarding/onboarding.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/validators.dart';

import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';

@RoutePage(name: 'LoginRoute')
class Login extends HookConsumerWidget {
  const Login({super.key});

  final _formKey = const GlobalObjectKey<FormState>('form');

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(loginViewModelProvider);

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final _areFieldsEmpty = useState(true);
    final obscureText = useState(true);

    bool areFieldsEmpty() {
      return emailController.text
          .toString()
          .isEmpty ||
          passwordController.text
              .toString()
              .isEmpty;
    }

    useEffect(() {
      void updateFieldsEmptyStatus() {
        _areFieldsEmpty.value = areFieldsEmpty();
        print("Fields empty: ${_areFieldsEmpty.value}");
      }

      emailController.addListener(updateFieldsEmptyStatus);
      passwordController.addListener(updateFieldsEmptyStatus);

      return () {
        emailController.removeListener(updateFieldsEmptyStatus);
        passwordController.removeListener(updateFieldsEmptyStatus);
      };
    }, [
      emailController,
      passwordController,
    ]);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus,
      child: Scaffold(
        body: Form(
          key: _formKey,
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
                    'Log in',
                    style: Theme
                        .of(context)
                        .textTheme
                        .displayLarge,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    'Log in with your email address and password',
                    style: Theme
                        .of(context)
                        .textTheme
                        .displaySmall!,
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Text(
                    'Email address',
                    style: Theme
                        .of(context)
                        .textTheme
                        .displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    hintText: 'Email address',
                    controller:
                    emailController,
                    validator: (val) {
                      if (!val!.isValidEmail || val.isEmpty) {
                        return 'Enter valid email address';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Password',
                    style: Theme
                        .of(context)
                        .textTheme
                        .displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    hintText: 'Password',
                    controller: passwordController,
                    validator: (val) {
                      if (!val!.isValidPassword || val.isEmpty) {
                        return 'Enter a valid password';
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
                  SizedBox(
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      locator<PayvidenceAppRouter>().navigateNamed(
                          PayvidenceRoutes.forgotPassword);
                      // context.push('/forgotPassword');
                    },
                    child: Text(
                      'Forgot password?',
                      style: Theme
                          .of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontSize: 14.sp, color: primaryColor2),
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  // viewModel.loginState.isLoading ? const LoadingIndicator():
                  AppButton(
                    buttonText: 'Log in',

                    isDisabled: _areFieldsEmpty.value,
                    isProcessing: viewModel.isLoading,
                    backgroundColor: !_areFieldsEmpty.value
                        ? primaryColor2
                        : primaryColor2.withOpacity(0.4),
                    onPressed: () {
                      print("Button pressed");
                      print("Fields empty: ${_areFieldsEmpty.value}");

                      if (_formKey.currentState!.validate()) {
                        log("Form is valid");
                        FocusScope.of(context).unfocus();
                        viewModel.login(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          navigateOnSuccess: () {
                            locator<PayvidenceAppRouter>().popUntil(
                                    (route) => route is OnboardingScreen);
                            locator<PayvidenceAppRouter>().replaceNamed(
                                PayvidenceRoutes.home);
                          },
                        );
                      } else {
                        log("Form is not valid");
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
