import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/app_button.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.gr.dart';

@RoutePage(name: 'AddBusinessSuccessRoute')
class AddBusinessSuccess extends StatelessWidget {
  const AddBusinessSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.svg.briefcaseConfetti),
            SizedBox(height: 40.h,),
            Text('Business added!', style: Theme.of(context).textTheme.displayLarge,),
            SizedBox(height: 10.h,),
            Text('Keekee Store has been successfully added to your account. You can start performing transactions for the business.',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, ))
          ],
        ),
      ),
      floatingActionButton: AppButton(buttonText: 'Alright!', onPressed: (){
        context.router.replace(const AllBusinessesRoute());
      }),
    );
  }
}
