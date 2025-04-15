import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/components/app_switch.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/profile/profile.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/theme_mode.dart';

@RoutePage(name: 'SettingsRoute')
class Settings extends HookWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            Text(
              'Settings',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 28.h),
            ProfileOptionTile(
              isDarkMode: isDarkMode,
              onTap: () {
                locator<PayvidenceAppRouter>().push(ChangePasswordRoute());
              },
              title: 'Change password',
              icon: Assets.svg.passwordCheck,
            ),
            ProfileOptionTile(
              isDarkMode: isDarkMode,
              onTap: () {
                locator<PayvidenceAppRouter>().push(ResetPasswordRoute());
              },
              title: 'Reset password',
              icon: Assets.svg.check,
            ),
            ProfileOptionTile(
              isDarkMode: isDarkMode,
              onTap: () {
                locator<PayvidenceAppRouter>()
                    .navigateNamed(PayvidenceRoutes.privacyAndSecurity);
              },
              title: 'Privacy and security',
              icon: Assets.svg.lockCircle,
            ),
            ProfileOptionTile(
              isDarkMode: isDarkMode,
              onTap: () {
                locator<PayvidenceAppRouter>()
                    .navigateNamed(PayvidenceRoutes.notificationSettings);
              },
              title: 'Notifications setting',
              icon: Assets.svg.notificationBing,
            ),
            SizedBox(height: 28.h),
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
                AppSwitch(
                  onChanged: (value) {
                    theme.toggle();
                  },
                  isSwitchEnabled: theme.mode == ThemeMode.dark,
                ),
              ],
            ),

            SizedBox(height: 11.h),
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
