import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';

final subscriptionPlansViewModelProvider =
    ChangeNotifierProvider((ref) => SubscriptionPlansViewModel(ref));

class SubscriptionPlansViewModel extends BaseChangeNotifier {
  final Ref ref;
  SubscriptionPlansViewModel(this.ref);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
    print('isLoading set to: $_isLoading');
  }

  Future<void> createSubscription({
    required String planId,
    required Function(String paymentLink, String callBackUrl, String cancelAction) navigateOnSuccess,
  }) async {

    _setLoading(true);
    try {
      final response = await apiServices.createSubscription(planId);

      if (response.success && response.data != null) {
        final paymentLink = response.data!['data']['payment_link'] as String?;
        final callBackUrl = response.data!['data']['callback_url'] as String?;
        final cancelAction = response.data!['data']['cancel_action'] as String?;

        if (paymentLink != null && callBackUrl != null && cancelAction != null) {
          navigateOnSuccess(paymentLink, callBackUrl, cancelAction);
        }
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            'An error occurred!';
        handleError(message: errorMessage);
      }
    } catch (e) {
      handleError(message: 'Something went wrong: $e');
    } finally {
      _setLoading(false);
    }
  }
}
