import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/app_button.dart';
import '../../components/app_text_field.dart';


@RoutePage(name: 'ResetPasswordRoute')
class ResetPassword extends StatelessWidget {
   ResetPassword({super.key});
final _passwordController = TextEditingController();
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
              Text('Enter password to enable', style: Theme.of(context).textTheme.displayLarge,),
              SizedBox(height: 8.h,),
              Text('Let us confirm it’s you.', style: Theme.of(context).textTheme.displaySmall!,),
              SizedBox(height: 32.h,),

              Text('Password', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Password', controller: _passwordController,
              ),
              SizedBox(height: 32.h,),
              AppButton(buttonText: 'Continue', onPressed: (){
                // context.go('/changePasswordSuccess');
              },),
            ],
          ),
        ),
      ),
    );
  }
}
