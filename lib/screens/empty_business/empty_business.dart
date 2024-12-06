import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/components/app_button.dart';

import '../../gen/assets.gen.dart';

class EmptyBusiness extends StatelessWidget {
  const EmptyBusiness({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.svg.emptyBriefcase),
            SizedBox(height: 40.h,),
            Text('No business added!', style: Theme.of(context).textTheme.displayLarge,),
            SizedBox(height: 10.h,),
            Text('Start generating receipts and invoices for your business. All transactions will show here.',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, ))
          ],
        ),
      ),
      floatingActionButton: AppButton(buttonText: 'Set-up business', onPressed: (){
        context.push('/addBusiness');
      }),
    );
  }
}
