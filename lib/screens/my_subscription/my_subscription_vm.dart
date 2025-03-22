import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';
import '../../model/subscription_model.dart';


final mySubscriptionViewModel = ChangeNotifierProvider((ref)=> MySubscriptionViewModel(ref));

class MySubscriptionViewModel extends BaseChangeNotifier{
  final Ref ref;
  MySubscriptionViewModel(this.ref);

  Subscription? _subscription;

  Subscription? get subInfo => _subscription;

  set subscriptionInfo(Subscription? subscription) {
    _subscription = subscription;
    notifyListeners();
    print("ViewModel: subscriptionInfo set to $_subscription");
  }

  Future<void> fetchSubscriptions() async {
    try {
      print("ViewModel: Fetching user information");
      final response = await apiServices.getPendingSubscriptions();
      print("ViewModel: API response - success: ${response.success}, data: ${response.data}");

      if (response.success) {

        final subData = response.data!["data"];
        // userInfo = User.fromJson(response.data!["data"]);
        subscriptionInfo = Subscription.fromJson(subData as Map<String, dynamic>);
        print("ViewModel: User info updated - $subInfo");
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "An error occurred!";
        print("ViewModel: API failed - $errorMessage");
        handleError(message: errorMessage);
      }
    } catch (e) {
      print("ViewModel: Exception - $e");
      throw Exception(e);
    }
  }

}