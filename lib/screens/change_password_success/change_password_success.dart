import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../components/app_button.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';



@RoutePage(name: 'ChangePasswordSuccessRoute')
class ChangePasswordSuccess extends StatelessWidget {
  const ChangePasswordSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AppButton(
          buttonText: 'Log in',
          onPressed: () {
            locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.home);
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
