import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import '../../components/app_switch.dart';
import '../../data/local/session_constants.dart';
import '../../data/local/session_manager.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'PrivacyAndSecurityRoute')
class PrivacyAndSecurity extends HookConsumerWidget {
  const PrivacyAndSecurity({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final isBiometricEnabled = useState<bool>(false);
    final responsiveData = ResponsiveInherited.of(context);

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

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: responsiveData.scaleHeight(16),
              ),
              Text(
                'Privacy and security',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: responsiveData.scaleHeight(32),
              ),
              Divider(
                thickness: responsiveData.scaleHeight(1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enable Biometric login',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(fontSize: Responsive.fontSize(context, 22)),
                  ),
                  AppSwitch(
                    isSwitchEnabled: isBiometricEnabled.value,
                    onChanged: (value) {
                      toggleBiometricLogin(value);
                    },
                  )
                ],
              ),
              SizedBox(
                height: responsiveData.scaleHeight(11),
              ),
              Text(
                'You will be able to log in to Payvidence App using your biometrics once enabled.',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(fontSize: Responsive.fontSize(context, 16)),
              ),
              SizedBox(
                height: responsiveData.scaleHeight(28),
              ),
              Divider(
                thickness: responsiveData.scaleHeight(1),
              ),
              // SizedBox(height: responsiveData.scaleHeight(28)),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text('Enable fingerprint to log in', style: Theme.of(context).textTheme.displaySmall!.copyWith(
              //         fontSize: Responsive.fontSize(context, 22)
              //     ),),
              //     CupertinoSwitch(value: true, onChanged: (value){})
              //   ],
              // ),
              // SizedBox(height: responsiveData.scaleHeight(11),),
              // Text('You will be able to log in to Payvidence App with your fingerprint once it is enabled.', style: Theme.of(context).textTheme.displaySmall!.copyWith(
              //     fontSize: Responsive.fontSize(context, 16)
              // ),),
              // SizedBox(height: responsiveData.scaleHeight(28),),
              // Divider(
              //   thickness: responsiveData.scaleHeight(1),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}