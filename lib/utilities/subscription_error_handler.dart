import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../components/simple_bottom_sheet.dart';
import '../routes/payvidence_app_router.dart';
import '../shared_dependency/shared_dependency.dart';
import 'responsive_wrapper.dart';
import 'toast_service.dart';

class SubscriptionErrorHandler {
  static bool isSubscriptionError(dynamic error) {
    if (error is DioException) {
      return error.response?.statusCode == 403;
    }
    return false;
  }

  static void handleSubscriptionError(BuildContext context, {String? customMessage}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final responsiveData = ResponsiveInherited.of(context);
    
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) => SimpleBottomSheet(
        isDarkMode: isDarkMode,
        title: 'Subscription Required',
        subtitle: customMessage ?? 'This feature requires an active subscription. Upgrade to continue.',
        height: responsiveData.scaleHeight(400),
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
              locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.chooseSubscriptionPlan);
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: responsiveData.scaleHeight(24)),
              child: Row(
                children: [
                  const Icon(Icons.upgrade, color: Colors.blue),
                  SizedBox(width: responsiveData.scaleWidth(16)),
                  Text(
                    'Upgrade Subscription',
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: Colors.blue,
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
                    style: Theme.of(context).textTheme.displaySmall!,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void handleError(BuildContext context, dynamic error) {
    if (isSubscriptionError(error)) {
      handleSubscriptionError(context);
    } else {

      String message = 'An error occurred';
      if (error is DioException) {
        message = error.response?.data['message'] ?? message;
      }
      ToastService.showErrorSnackBar(message);
    }
  }
}