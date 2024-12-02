import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h,),
              Text('Log in', style: Theme.of(context).textTheme.displayLarge,),
              SizedBox(height: 8.h,),
              Text('Log in with your email address and password', style: Theme.of(context).textTheme.displaySmall!,),
              SizedBox(height: 32.h,),
              Text('Email address', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'First Name', controller: _emailController,),
              SizedBox(height: 20.h,),
              Text('Password', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Password', controller: _emailController, suffixIcon: Padding(
                padding: EdgeInsets.all(16.h),
                child: SvgPicture.asset(Assets.svg.password, height: 24.h, width: 24.w,),
              ),),
              SizedBox(height: 20.h,),
              GestureDetector(
                onTap: (){
                  context.push('/forgotPassword');
                },
                child: Text('Forgot password?',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 14.sp, color: primaryColor2),),
              ),
              SizedBox(height: 32.h,),
              AppButton(buttonText: 'Log in', onPressed: (){
                context.go('/home');
              },),
            ],
          ),
        ),
      ),
    );
  }
}
