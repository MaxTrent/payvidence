import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payvidence/components/loading_indicator.dart';
import 'package:payvidence/screens/login/login_vm.dart';
import 'package:payvidence/utilities/validators.dart';

import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';


@RoutePage(name: 'LoginRoute')
class Login extends ConsumerWidget {
  const Login({super.key});

  final _formKey = const GlobalObjectKey<FormState>('form');


  @override
  Widget build(BuildContext context, ref) {
    final viewModel = LoginViewModel(ref);

    return GestureDetector(
      onTap: ()=> FocusManager.instance.primaryFocus!.unfocus,
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
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    'Log in with your email address and password',
                    style: Theme.of(context).textTheme.displaySmall!,
                  ),
                  SizedBox(
                    height: 32.h,
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
                    controller: ref.watch(LoginViewModel.emailControllerProvider),
                 validator:  (val) {
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
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    hintText: 'Password',
                    controller: ref.watch(LoginViewModel.passwordControllerProvider),
                    validator: (val) {
                          if (!val!.isValidPassword || val.isEmpty) {
                            return 'Enter a valid password';
                          }
                          return null;
                        },
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(16.h),
                      child: GestureDetector(
                        onTap: ()=>viewModel.switchVisibility(),
                        child: SvgPicture.asset(
                          Assets.svg.password,
                          height: 24.h,
                          width: 24.w,
                        ),
                      ),
                    ),
                    obscureText: ref.watch(LoginViewModel.obscureTextProvider),

                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      // context.push('/forgotPassword');
                    },
                    child: Text(
                      'Forgot password?',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontSize: 14.sp, color: primaryColor2),
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  viewModel.loginState.isLoading ? const LoadingIndicator():
                  AppButton(
                    buttonText: 'Log in',
                     backgroundColor:viewModel.areAllFieldsFilled() ? primaryColor2 : primaryColor2.withOpacity(0.4),
                    onPressed: () {
                                print("Button pressed");
                                if (viewModel.areAllFieldsFilled()) {
                                  print("All fields are filled");
                                  if (_formKey.currentState!.validate()) {
                                    print("Form is valid");
                                    viewModel.login();
                                  } else {
                                    print("Form is not valid");
                                  }
                                } else {
                                  print("Not all fields are filled");
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
