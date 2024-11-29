import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/constants/app_colors.dart';

import '../../components/app_text_field.dart';

class CreateAccountScreen extends StatelessWidget {
   CreateAccountScreen({super.key});

  final _firstNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h,),
            Text('Enter your details', style: Theme.of(context).textTheme.displayLarge,),
            SizedBox(height: 8.h,),
            Text('Create an account to enjoy Payvidence.', style: Theme.of(context).textTheme.displaySmall!,),
            SizedBox(height: 32.h,),
            Text('First name', style: Theme.of(context).textTheme.displaySmall,),
            SizedBox(height: 8.h,),
            AppTextField(hintText: 'First Name', controller: _firstNameController,),
            SizedBox(height: 20.h,),
            Text('Last name', style: Theme.of(context).textTheme.displaySmall,),
            SizedBox(height: 8.h,),
            AppTextField(hintText: 'Last Name', controller: _firstNameController,),
            SizedBox(height: 20.h,),
            Text('Email address', style: Theme.of(context).textTheme.displaySmall,),
            SizedBox(height: 8.h,),
            AppTextField(hintText: 'Email address', controller: _firstNameController,),
            SizedBox(height: 20.h,),
            Text('Phone number', style: Theme.of(context).textTheme.displaySmall,),
            SizedBox(height: 8.h,),
            AppTextField(hintText: 'Phone number', controller: _firstNameController,),
            SizedBox(height: 20.h,),
            Text('Password', style: Theme.of(context).textTheme.displaySmall,),
            SizedBox(height: 8.h,),
            AppTextField(hintText: 'Password (8+ characters)', controller: _firstNameController,),
            SizedBox(height: 20.h,),
            Text.rich(TextSpan(
              text: 'By continuing, you agree to Payvidence’s ',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp),
              children: [
                TextSpan(text: 'Terms & Conditions', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700)),
                TextSpan(text: ' and '),
                TextSpan(text: 'Privacy Policy', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, fontWeight: FontWeight.w700)),

              ]
            )),
            SizedBox(height: 32.h,),
            AppButton(buttonText: 'Create account', onPressed: (){
              context.push('/otp');
            },),
          ],
        ),
      ),
    );
  }
}

