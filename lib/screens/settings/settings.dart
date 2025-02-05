import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 import 'package:payvidence/screens/profile/profile.dart';

import '../../gen/assets.gen.dart';
import '../../routes/app_routes.dart';
import '../../routes/app_routes.gr.dart';


@RoutePage(name: 'SettingsRoute')
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
            SizedBox(
              height: 28.h,
            ),
            ProfileOptionTile(
                icon: Assets.svg.passwordCheck,
                title: 'Change password',
                onTap: (){
                  context.router.push(ChangePasswordRoute());
                },
                // navigateTo: AppRoutes.changePassword
            ),
            ProfileOptionTile(
                icon: Assets.svg.check,
                title: 'Reset password',
              onTap: (){
                context.router.push(ResetPasswordRoute());
              },
                // navigateTo: AppRoutes.resetPassword
            ),
            ProfileOptionTile(
                icon: Assets.svg.lockCircle,
                title: 'Privacy and security',
                // navigateTo: AppRoutes.privacyAndSecurity,
              onTap: (){
                context.router.push(PrivacyAndSecurityRoute());
              },
            ),
            ProfileOptionTile(
                icon: Assets.svg.notificationBing,
                title: 'Notifications setting',
                // navigateTo: AppRoutes.notificationSettings
                onTap: (){
                context.router.push(NotificationSettingsRoute());
      },
            ),
            SizedBox(
              height: 28.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Switch to dark mode',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontSize: 22.sp),
                ),
                CupertinoSwitch(value: true, onChanged: (value) {})
              ],
            ),
            SizedBox(
              height: 11.h,
            ),
            Text(
              'You can use Payvidence App on dark mode too. Turn on the switch to get started.',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 16.sp),
            ),
          ],
        ),
      ),
    );
  }
}
