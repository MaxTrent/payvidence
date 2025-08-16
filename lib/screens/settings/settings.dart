import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:payvidence/components/app_switch.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/profile/profile.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import 'package:payvidence/utilities/animations.dart';
import 'package:payvidence/utilities/delete_account_helper.dart';
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
    final responsiveData = ResponsiveInherited.of(context);

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: responsiveData.scaleHeight(8)),
              FadeInWidget(
                child: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(28)),
              SlideInWidget(
                begin: const Offset(0, 0.3),
                delay: const Duration(milliseconds: 100),
                child: ProfileOptionTile(
                  isDarkMode: isDarkMode,
                  onTap: () {
                    locator<PayvidenceAppRouter>().push(ChangePasswordRoute());
                  },
                  title: 'Change password',
                  icon: Assets.svg.passwordCheck,
                ),
              ),
              SlideInWidget(
                begin: const Offset(0, 0.3),
                delay: const Duration(milliseconds: 150),
                child: ProfileOptionTile(
                  isDarkMode: isDarkMode,
                  onTap: () {
                    locator<PayvidenceAppRouter>().push(ResetPasswordRoute());
                  },
                  title: 'Reset password',
                  icon: Assets.svg.check,
                ),
              ),
              SlideInWidget(
                begin: const Offset(0, 0.3),
                delay: const Duration(milliseconds: 200),
                child: ProfileOptionTile(
                  isDarkMode: isDarkMode,
                  onTap: () {
                    locator<PayvidenceAppRouter>()
                        .navigateNamed(PayvidenceRoutes.privacyAndSecurity);
                  },
                  title: 'Privacy and security',
                  icon: Assets.svg.lockCircle,
                ),
              ),
              SlideInWidget(
                begin: const Offset(0, 0.3),
                delay: const Duration(milliseconds: 250),
                child: ProfileOptionTile(
                  isDarkMode: isDarkMode,
                  onTap: () {
                    locator<PayvidenceAppRouter>()
                        .navigateNamed(PayvidenceRoutes.notificationSettings);
                  },
                  title: 'Notifications setting',
                  icon: Assets.svg.notificationBing,
                ),
              ),
              SlideInWidget(
                begin: const Offset(0, 0.3),
                delay: const Duration(milliseconds: 300),
                child: ProfileOptionTile(
                  isDarkMode: isDarkMode,
                  onTap: () => DeleteAccountHelper.showDeleteAccountDialog(context),
                  title: 'Delete account',
                  icon: Assets.svg.delete,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(28)),
              SlideInWidget(
                begin: const Offset(0, 0.3),
                delay: const Duration(milliseconds: 300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Switch to dark mode',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall!
                          .copyWith(fontSize: Responsive.fontSize(context, 22)),
                    ),
                    AppSwitch(
                      onChanged: (value) {
                        theme.toggle();
                      },
                      isSwitchEnabled: theme.mode == ThemeMode.dark,
                    ),
                  ],
                ),
              ),
              SizedBox(height: responsiveData.scaleHeight(11)),
              FadeInWidget(
                delay: const Duration(milliseconds: 350),
                child: Text(
                  'You can use Payvidence App on dark mode too. Turn on the switch to get started.',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontSize: Responsive.fontSize(context, 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}