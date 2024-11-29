import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payvidence/components/app_button.dart';

import '../../gen/assets.gen.dart';

class AccountSuccessScreen extends StatelessWidget {
  const AccountSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AppButton(buttonText: 'Go to Home', onPressed: (){
        showModalBottomSheet(context: context, builder: (context){
          return Container();
        });
      }),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.svg.profileConfetti),
            SizedBox(height: 40.h,),
            Text('Account created!', style: Theme.of(context).textTheme.displayLarge,),
            SizedBox(height: 10.h,),
            Text('Your account has been successfully created. You can log in now to proceed to Home.',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!,),
            SizedBox(height: 32.h,),

          ],
        ),
      ),
    );
  }
}
