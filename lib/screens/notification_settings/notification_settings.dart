import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_switch.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/update_personal_details/update_personal_details_vm.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'NotificationSettingsRoute')
class NotificationSettings extends HookConsumerWidget {
  const NotificationSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(updatePersonalDetailsViewModelProvider);

    // State for switches
    final isTransactionAlertEnabled = useState(false);
    final isPromotionalUpdateEnabled = useState(false);
    final isSecurityAlertEnabled = useState(false);

    // Fetch user info on load
    useEffect(() {
      print("Fetching user info for notification settings");
      viewModel.fetchUserInformation();
      return null;
    }, []);

    // Update switch states when user info is loaded
    useEffect(() {
      if (viewModel.userInfo != null && !viewModel.isLoading) {
        print("Updating switch states with user info: ${viewModel.userInfo}");
        isTransactionAlertEnabled.value = viewModel.userInfo?.account.transactionalAlerts ?? false;
        isPromotionalUpdateEnabled.value = viewModel.userInfo?.account.promotionalUpdates ?? false;
        isSecurityAlertEnabled.value = viewModel.userInfo?.account.securityAlerts ?? false;
      }
      return null;
    }, [viewModel.userInfo, viewModel.isLoading]);

    // Function to update notification settings
    void updateNotificationSettings({
      bool? transactionalAlerts,
      bool? promotionalUpdates,
      bool? securityAlerts,
    }) {
      // Use current switch states if specific values aren't provided
      final updatedTransactionalAlerts = transactionalAlerts ?? isTransactionAlertEnabled.value;
      final updatedPromotionalUpdates = promotionalUpdates ?? isPromotionalUpdateEnabled.value;
      final updatedSecurityAlerts = securityAlerts ?? isSecurityAlertEnabled.value;

      viewModel.updateUserInfo(
       transactionalAlerts: updatedTransactionalAlerts,
        promotionalUpdates: updatedPromotionalUpdates,
        securityAlerts: updatedSecurityAlerts,
        navigateOnSuccess: () {
          print("Notification settings updated successfully");
          // Optionally navigate back or stay on the screen
          // locator<PayvidenceAppRouter>().back();
        },
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Text(
              'Notifications setting',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 32.h),
            Divider(thickness: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactional alerts',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontSize: 22.sp),
                ),
                AppSwitch(
                  onChanged: (value) {
                    isTransactionAlertEnabled.value = value;
                    updateNotificationSettings(transactionalAlerts: value);
                  },
                  isSwitchEnabled: isTransactionAlertEnabled.value,
                ),
              ],
            ),
            SizedBox(height: 11.h),
            Text(
              'You will receive notifications about new receipts, invoices, products, and clients.',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 16.sp),
            ),
            SizedBox(height: 28.h),
            Divider(thickness: 1.h),
            SizedBox(height: 28.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Promotional updates',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontSize: 22.sp),
                ),
                AppSwitch(
                  onChanged: (value) {
                    isPromotionalUpdateEnabled.value = value;
                    updateNotificationSettings(promotionalUpdates: value);
                  },
                  isSwitchEnabled: isPromotionalUpdateEnabled.value,
                ),
              ],
            ),
            SizedBox(height: 11.h),
            Text(
              'You will get notifications about new features, updates, or promotions within the app.',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 16.sp),
            ),
            SizedBox(height: 28.h),
            Divider(thickness: 1.h),
            SizedBox(height: 28.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Security alerts',
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(fontSize: 22.sp),
                ),
                AppSwitch(
                  onChanged: (value) {
                    isSecurityAlertEnabled.value = value;
                    updateNotificationSettings(securityAlerts: value);
                  },
                  isSwitchEnabled: isSecurityAlertEnabled.value,
                ),
              ],
            ),
            SizedBox(height: 11.h),
            Text(
              'You will be notified of new or unrecognized devices and any suspicious account activity.',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(fontSize: 16.sp),
            ),
            SizedBox(height: 28.h),
            Divider(thickness: 1.h),
          ],
        ),
      ),
    );
  }
}

