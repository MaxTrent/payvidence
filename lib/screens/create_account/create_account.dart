import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/screens/create_account/create_account_vm.dart';
import 'package:payvidence/utilities/validators.dart';

import '../../components/app_text_field.dart';
import '../../gen/assets.gen.dart';

class CreateAccountScreen extends ConsumerWidget {
  CreateAccountScreen({super.key});

  final _formKey = GlobalObjectKey<FormState>('form');
  final _firstNameController = TextEditingController();

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = CreateAccountViewModel(ref);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // appBar: AppBar(),
        body: Padding(
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
                  controller: viewModel.textEditingController('firstname'),
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
                  controller: viewModel.textEditingController('lastname'),
                  validator: (val) {
                    if (!val!.isValidPassword || val.isEmpty) {
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
                  controller: viewModel.textEditingController('email'),
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
                  controller: viewModel.textEditingController('phone'),
                  validator: (val) {
                    if (!val!.isValidPhone || val.isEmpty) {
                      return 'Enter a valid password';
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
                  controller: viewModel.textEditingController('password'),
                  obscureText: viewModel.obscureText('password'),
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: GestureDetector(
                        onTap: () => viewModel.switchVisibility('password'),
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
                  controller:
                      viewModel.textEditingController('confirmPassword'),
                  obscureText: viewModel.obscureText('confirmPassword'),
                  validator: (val) {
                    if (!val!.isValidPassword || val.isEmpty) {
                      return 'Enter a valid password';
                    }
                    return null;
                  },
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(16.h),
                    child: GestureDetector(
                        onTap: () =>
                            viewModel.switchVisibility('confirmPassword'),
                        child: SvgPicture.asset(Assets.svg.password)),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text.rich(TextSpan(
                    text: 'By continuing, you agree to Payvidence’s ',
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
                      TextSpan(text: ' and '),
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
                AppButton(
                  buttonText: 'Create account',
                  onPressed: () {
                    context.push('/otp');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
