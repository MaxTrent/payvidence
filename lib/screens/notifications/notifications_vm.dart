import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/notification_model.dart';
import 'package:payvidence/utilities/base_notifier.dart';

final notificationsViewModel =
    ChangeNotifierProvider((ref) => NotificationsViewModel(ref));

class NotificationsViewModel extends BaseChangeNotifier {
  final Ref ref;
  NotificationsViewModel(this.ref);

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  // Notification? _selectedPlan;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  // Notification? get selectedPlan => _selectedPlan;

  set notifications(List<NotificationModel> value) {
    _notifications = value;
    notifyListeners();
    print("ViewModel: plans set to $_notifications");
  }

  set selectedNotification(NotificationModel? value) {
    // _selectedPlan = value;
    // notifyListeners();
    // print("ViewModel: selectedPlan set to $_selectedPlan");
  }

  Future<void> fetchNotifications() async {
    try {
      _isLoading = true;
      notifyListeners();

      print("ViewModel: Fetching plans");
      final response = await apiServices.getAllNotifications();
      print(
          "ViewModel: API response - success: ${response.success}, data: ${response.data}");

      if (response.success) {
        final notificationData = response.data!["data"];
        if (notificationData is List) {
          notifications = notificationData
              .map((item) =>
                  NotificationModel.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          print("ViewModel: Unexpected data format - $notificationData");
          handleError(message: "Unexpected data format");
          return;
        }
        print("ViewModel: Plans updated - $notifications");
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "An error occurred!";
        print("ViewModel: API failed - $errorMessage");
        handleError(message: errorMessage);
      }
    } catch (e) {
      print("ViewModel: Exception - $e");
      handleError(message: "Something went wrong. Please try again.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
