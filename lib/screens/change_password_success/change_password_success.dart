import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../components/app_button.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';

class ChangePasswordSuccess extends StatelessWidget {
  const ChangePasswordSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AppButton(
          buttonText: 'Log in',
          onPressed: () {
            context.go('/home');
          }),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.svg.passwordSuccess),
              SizedBox(
                height: 40.h,
              ),
              Text(
                'Password changed!',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Your password has been successfully changed. You can log in now to proceed to Home.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall!,
              ),
              SizedBox(
                height: 32.h,
              ),
            ],
          ),
        ),
      ),

    );
  }
}
