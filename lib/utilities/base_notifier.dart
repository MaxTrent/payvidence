import 'package:flutter/cupertino.dart';
import 'package:payvidence/data/api_services.dart';
import 'package:payvidence/utilities/toast_service.dart';
import '../shared_dependency/shared_dependency.dart';
import 'enum.dart';
import 'notification_service.dart';



class BaseChangeNotifier extends ChangeNotifier {
  late ApiServices apiServices;
  late NotificationService notificationService;

  BaseChangeNotifier(
      {
        ApiServices? apiServices,
      })
  {
    this.apiServices = apiServices ?? locator();
  }

  void handleError({
    String? message,
    bool shouldDisplayError = true,
  }) {
    showToastMessage(
        message: message != "null" ? message.toString() : "An error occured",
        type: ToastMessageType.failure);
  }

  void showToastMessage({
    required String message,
    required ToastMessageType type,
  }) {
    ToastService.error(
      message != "null" && message != null ? message.toString() : "An error occurred",
    );
  }

  void showSuccess({
    required BuildContext context,
    required String message,
  }) {
    ToastService.success(message);
  }

  void scheduleNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) {
    notificationService.scheduleNotification(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
    );
  }
}
