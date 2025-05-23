import 'package:flutter/cupertino.dart';
import 'package:payvidence/data/api_services.dart';
import 'package:payvidence/utilities/toast_service.dart';
import '../shared_dependency/shared_dependency.dart';
import 'enum.dart';
import 'notification_service.dart';

class BaseChangeNotifier extends ChangeNotifier {
  late ApiServices apiServices;
  late NotificationService _notificationService;

  BaseChangeNotifier({
    ApiServices? apiServices,
    NotificationService? notificationService, // Optional parameter
  }) {
    this.apiServices = apiServices ?? locator<ApiServices>();
    _notificationService =
        notificationService ?? locator<NotificationService>();
  }

  void handleError({
    String? message,
    bool shouldDisplayError = true,
  }) {
    if (shouldDisplayError) {
      showErrorToastMessage(
        message: message ?? "An error occurred",
        type: ToastMessageType.failure,
      );
    }
  }

  void showErrorToastMessage({
    required String message,
    required ToastMessageType type,
  }) {
    String errorMsg = message != "null" ? message : "An error occurred";
    ToastService.showErrorSnackBar(errorMsg);
    _notificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      title: 'Error',
      body: errorMsg,
    );
  }

  void showSuccess({
    required String message,
  }) {
    ToastService.showSnackBar(message);
    _notificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      title: 'Success',
      body: message,
    );
  }

  void scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) {
    _notificationService.scheduleNotification(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
    );
  }
}
