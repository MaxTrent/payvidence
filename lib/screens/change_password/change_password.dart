import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../components/app_button.dart';
import '../../components/app_text_field.dart';

class ChangePassword extends StatelessWidget {
   ChangePassword({super.key});

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h,),
              Text('Change your password', style: Theme.of(context).textTheme.displayLarge,),
              SizedBox(height: 8.h,),
              Text('Enter your previous password and set new one.', style: Theme.of(context).textTheme.displaySmall!,),
              SizedBox(height: 32.h,),
              Text('Current password', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Current password', controller: _passwordController,),
              SizedBox(height: 20.h,),
              Text('New password', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'New password', controller: _passwordController,),
              SizedBox(height: 20.h,),
              Text('Confirm new password', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Re-enter new password', controller: _confirmPasswordController,
              ),
              SizedBox(height: 32.h,),
              AppButton(buttonText: 'Change password', onPressed: (){
                context.go('/changePasswordSuccess');
              },),
            ],
          ),
        ),
      ),
    );
  }
}
