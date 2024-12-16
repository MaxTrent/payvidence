import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyAndSecurity extends StatelessWidget {
  const PrivacyAndSecurity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h,),
            Text('Privacy and security', style: Theme.of(context).textTheme.displayLarge,),
           SizedBox(height: 32.h,),
            Divider(
              thickness: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Enable face ID to log in', style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 22.sp
                ),),
                CupertinoSwitch(value: true, onChanged: (value){})
              ],
            ),
            SizedBox(height: 11.h,),
            Text('You will be able to log in to Payvidence App with your face ID once it is enabled.', style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 16.sp
            ),),
            SizedBox(height: 28.h,),
            Divider(
              thickness: 1.h,
            ),
            SizedBox(height: 28.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Enable fingerprint to log in', style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    fontSize: 22.sp
                ),),
                CupertinoSwitch(value: true, onChanged: (value){})
              ],
            ),
            SizedBox(height: 11.h,),
            Text('You will be able to log in to Payvidence App with your fingerprint once it is enabled.', style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 16.sp
            ),),
            SizedBox(height: 28.h,),
            Divider(
              thickness: 1.h,
            ),
          ],
        ),
      ),
    );
  }
}
