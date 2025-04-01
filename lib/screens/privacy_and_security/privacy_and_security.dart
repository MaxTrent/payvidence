import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/constants/app_colors.dart';
import '../../data/local/session_constants.dart';
import '../../data/local/session_manager.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'PrivacyAndSecurityRoute')
class PrivacyAndSecurity extends HookConsumerWidget {
  const PrivacyAndSecurity({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final isBiometricEnabled = useState<bool>(false);

    useEffect(() {
      Future<void> loadInitialState() async {
        final savedValue = await locator<SessionManager>()
            .get<bool>(SessionConstants.isBiometricLoginEnabled);
        isBiometricEnabled.value = savedValue ?? false;
      }

      loadInitialState();
      return null;
    }, []);

    Future<void> toggleBiometricLogin(bool value) async {
      isBiometricEnabled.value = value;
      await locator<SessionManager>().save(
        key: SessionConstants.isBiometricLoginEnabled,
        value: value,
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16.h,
            ),
            Text(
              'Privacy and security',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(
              height: 32.h,
            ),
            Divider(
              thickness: 1.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Enable Biometric login',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontSize: 22.sp),
                ),
                CupertinoSwitch(
                  value: isBiometricEnabled.value,
                  onChanged: (value) {
                    toggleBiometricLogin(value);
                  },
                  activeColor: primaryColor2,
                  thumbColor: appGrey,
                  //inactiveColor: borderColor,
                )
              ],
            ),
            SizedBox(
              height: 11.h,
            ),
            Text(
              'You will be able to log in to Payvidence App using your biometrics once enabled.',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 16.sp),
            ),
            SizedBox(
              height: 28.h,
            ),
            Divider(
              thickness: 1.h,
            ),
            // SizedBox(height: 28.h,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text('Enable fingerprint to log in', style: Theme.of(context).textTheme.displaySmall!.copyWith(
            //         fontSize: 22.sp
            //     ),),
            //     CupertinoSwitch(value: true, onChanged: (value){})
            //   ],
            // ),
            // SizedBox(height: 11.h,),
            // Text('You will be able to log in to Payvidence App with your fingerprint once it is enabled.', style: Theme.of(context).textTheme.displaySmall!.copyWith(
            //     fontSize: 16.sp
            // ),),
            // SizedBox(height: 28.h,),
            // Divider(
            //   thickness: 1.h,
            // ),
          ],
        ),
      ),
    );
  }
}
