import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';
import '../../model/subscription_model.dart';

final mySubscriptionViewModel =
    ChangeNotifierProvider((ref) => MySubscriptionViewModel(ref));

class MySubscriptionViewModel extends BaseChangeNotifier {
  final Ref ref;
  MySubscriptionViewModel(this.ref);

  List<Subscription> _subscriptions = [];

  List<Subscription> get subscriptions => _subscriptions;

  // set subscriptionInfo(Subscription? subscription) {
  //   _subscription = subscription;
  //   notifyListeners();
  //   print("ViewModel: subscriptionInfo set to $_subscription");
  // }

  Subscription? get subInfo {
    return _subscriptions.firstWhereOrNull((sub) => sub.status == "active");
  }

  List<Subscription> get expiredSubscriptions {
    return _subscriptions.where((sub) => sub.status == "expired").toList();
  }

  // List<Subscription> get pendingSubscriptions {
  //   return _subscriptions.where((sub) => sub.status == "pending").toList();
  // }

  set subscriptionsInfo(List<Subscription> subscriptions) {
    _subscriptions = subscriptions;
    notifyListeners();
    print("ViewModel: subscriptionsInfo set to $_subscriptions");
  }

  Future<void> fetchSubscriptions() async {
    try {
      print("ViewModel: Fetching user information");
      final response = await apiServices.getPendingSubscriptions();
      print(
          "ViewModel: API response - success: ${response.success}, data: ${response.data}");

      if (response.success) {
        final subData = response.data!["data"];
        if (subData is List) {
          subscriptionsInfo = subData
              .map(
                  (item) => Subscription.fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (subData is Map<String, dynamic>) {
          subscriptionsInfo = [Subscription.fromJson(subData)];
        } else {
          print("ViewModel: Unexpected data format - $subData");
          handleError(message: "Unexpected subscription data format");
          return;
        }
        print("ViewModel: Subscriptions updated - $subscriptions");
        print("ViewModel: Active or Pending subscription - $subInfo");
        print("ViewModel: Expired subscriptions - $expiredSubscriptions");
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
    }
  }
}
