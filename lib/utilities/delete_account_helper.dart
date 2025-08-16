import 'package:flutter/material.dart';
import 'package:payvidence/components/delete_account_bottom_sheet.dart';
import 'package:payvidence/data/api_services.dart';
import 'package:payvidence/utilities/toast_service.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';

class DeleteAccountHelper {
  static void showDeleteAccountDialog(BuildContext context) {
    print('DeleteAccountHelper: showDeleteAccountDialog called');
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext bottomSheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
        ),
        child: DeleteAccountBottomSheet(
          onConfirm: (password, resetLoading) async {
            try {
              final response = await ApiServices().deleteAccount(password);
              
              if (response.success) {
                if (Navigator.canPop(bottomSheetContext)) {
                  Navigator.pop(bottomSheetContext);
                }
                ToastService.showSnackBar('Account deleted successfully');
                // Clear user data and navigate to login
                locator<PayvidenceAppRouter>().replaceAll([OnboardingScreenRoute()]);
              } else {
                if (Navigator.canPop(bottomSheetContext)) {
                  Navigator.pop(bottomSheetContext);
                }
                ToastService.showErrorSnackBar(response.error?.message ?? 'Failed to delete account');
              }
            } catch (e) {
              if (Navigator.canPop(bottomSheetContext)) {
                Navigator.pop(bottomSheetContext);
              }
              ToastService.showErrorSnackBar('An error occurred. Please try again.');
            }
          },
        ),
      ),
    );
  }
}