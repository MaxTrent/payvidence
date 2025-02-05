import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/components/loading_indicator.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/screens/create_account/create_account_vm.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_text_field.dart';
import '../../gen/assets.gen.dart';


@RoutePage(name: 'CreateAccountRoute')
class CreateAccountScreen extends ConsumerWidget {
  const CreateAccountScreen({super.key});

  final _formKey = const GlobalObjectKey<FormState>('form');

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = CreateAccountViewModel(ref);


    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // appBar: AppBar(),
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
                    controller: ref.watch(
                        CreateAccountViewModel.firstNameControllerProvider),
                    validator: (val) {
                      if (!val!.isValidName || val.isEmpty) {
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
                    controller: ref.watch(
                        CreateAccountViewModel.lastNameControllerProvider),
                    validator: (val) {
                      if (!val!.isValidName || val.isEmpty) {
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
                    controller: ref.watch(
                        CreateAccountViewModel.emailControllerProvider),
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
                    'Phone number',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    hintText: 'Phone number',
                    keyboardType: TextInputType.number,
                    controller: ref.watch(
                        CreateAccountViewModel.phoneControllerProvider),

                    validator: (val) {
                      if (!val!.isValidPhone || val.isEmpty) {
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
                      if (!val!.isValidPassword || val.isEmpty) {
                        return 'Enter a valid password';
                      }
                      return null;
                    },
                    controller: ref.watch(
                        CreateAccountViewModel.passwordControllerProvider),
                    obscureText:
                        viewModel.obscurePasswordConfirm,
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(16.h),
                      child: GestureDetector(
                          onTap: () => viewModel.switchPasswordVisibility,
                          child: SvgPicture.asset(Assets.svg.password)),
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
                    controller: ref.watch(
                        CreateAccountViewModel.passwordConfirmControllerProvider),
                    obscureText: viewModel
                        .obscurePasswordConfirm,
                    validator: (val) {
                      final password = ref.watch(
                          CreateAccountViewModel.passwordControllerProvider)
                      .text;
                      if (!val!.isValidPassword || val.isEmpty) {
                        return 'Enter a valid password';
                      }
                      if (val != password) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(16.h),
                      child: GestureDetector(
                          onTap: () => viewModel.switchPasswordConfirmVisibility,
                          child: SvgPicture.asset(Assets.svg.password)),
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
                  viewModel.createAccountState.isLoading
                      ? const LoadingIndicator()
                      : AppButton(
                          buttonText: 'Create account',
                          backgroundColor: viewModel.areAllFieldsFilled() ? primaryColor2 : primaryColor2.withOpacity(0.4),
                          onPressed: () {
                            print("Button pressed");
                            if (viewModel.areAllFieldsFilled()) {
                              print("All fields are filled");
                              if (_formKey.currentState!.validate()) {
                                print("Form is valid");
                                viewModel.createAccount();
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
