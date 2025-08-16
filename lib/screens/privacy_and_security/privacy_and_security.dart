import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import '../../components/app_switch.dart';
import '../../components/simple_bottom_sheet.dart';
import '../../constants/app_colors.dart';
import '../../data/local/session_constants.dart';
import '../../data/local/session_manager.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/theme_mode.dart';
import '../../utilities/toast_service.dart';

@RoutePage(name: 'PrivacyAndSecurityRoute')
class PrivacyAndSecurity extends HookConsumerWidget {
  const PrivacyAndSecurity({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final isBiometricEnabled = useState<bool>(false);
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
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

            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountModal(BuildContext context, bool isDarkMode) {
    final responsiveData = ResponsiveInherited.of(context);
    showModalBottomSheet<void>(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) => SimpleBottomSheet(
        isDarkMode: isDarkMode,
        title: 'Delete Account',
        subtitle: 'Are you sure you want to delete your account? This action cannot be undone.',
        height: 500,
        children: [
          InkWell(
            onTap: () async {
              Navigator.of(context).pop();
              await _deleteAccount();
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
              child: Row(
                children: [
                  const Icon(
                    Icons.delete,
                    color: appRed,
                  ),
                  SizedBox(width: responsiveData.scaleWidth(16)),
                  Text(
                    'Delete Account',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(
                      fontSize: Responsive.fontSize(context, 14),
                      color: appRed,
                    ),
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
              child: Row(
                children: [
                  Icon(
                    Icons.close,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  SizedBox(width: responsiveData.scaleWidth(16)),
                  Text(
                    'Cancel',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall!
                        .copyWith(
                      fontSize: Responsive.fontSize(context, 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount() async {
    try {
      // TODO: Replace with actual delete account API endpoint
      // await apiService.deleteAccount();
      
      // Placeholder for API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Show success message
      ToastService.success('Account deleted successfully');
      
      // TODO: Navigate to login/onboarding screen after successful deletion
      // locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.onboarding);
      
    } catch (e) {
      // Handle error cases
      ToastService.error('Failed to delete account. Please try again.');
    }
  }
}