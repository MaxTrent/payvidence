import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payvidence/screens/profile/profile.dart';

import '../../gen/assets.gen.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 8.h,
            ),
            Text(
              'Settings',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 28.h,),
            ProfileOptionTile(icon: Assets.svg.passwordCheck, title: 'Change password', navigateTo: ''),
            ProfileOptionTile(icon: Assets.svg.check, title: 'Reset password', navigateTo: ''),
            ProfileOptionTile(icon: Assets.svg.lockCircle, title: 'Privacy and security', navigateTo: ''),
            ProfileOptionTile(icon: Assets.svg.notificationBing, title: 'Notifications setting', navigateTo: ''),
         SizedBox(height: 28.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Switch to dark mode', style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontSize: 22.sp
                ),),
                CupertinoSwitch(value: true, onChanged: (value){})
              ],
            ),
            SizedBox(height: 11.h,),
            Text('You can use Payvidence App on dark mode too. Turn on the switch to get started.', style: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 16.sp
            ),),
          ],
        ),
      ),
    );
  }
}
