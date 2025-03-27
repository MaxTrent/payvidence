import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';


final subscriptionPlansViewModel = ChangeNotifierProvider((ref)=>SubscriptionPlansViewModel(ref));

class SubscriptionPlansViewModel extends BaseChangeNotifier{
  final Ref ref;
  SubscriptionPlansViewModel(this.ref);


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> createSubscription({
    required String planId,
    required Function(String paymentLink) navigateOnSuccess,
  }) async {
    _setLoading(true);
    try {
      final response = await apiServices.createSubscription(planId);

      if (response.success && response.data != null) {
        final paymentLink = response.data!['payment_link'] as String?;
        if (paymentLink != null) {
          navigateOnSuccess(paymentLink);
        } else {
          handleError(message: 'Payment link not found in response');
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