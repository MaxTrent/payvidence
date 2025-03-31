import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';

import '../../data/local/session_constants.dart';
import '../../data/local/session_manager.dart';
import '../../model/user_model.dart';
import '../../shared_dependency/shared_dependency.dart';

final forgotPasswordViewModelProvider =
    ChangeNotifierProvider((ref) => ForgotPasswordViewModel(ref));

class ForgotPasswordViewModel extends BaseChangeNotifier {
  final Ref ref;
  ForgotPasswordViewModel(this.ref);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> forgotPasswordInit({
    required String email,
    required Function() navigateOnSuccess,
  }) async {
    _setLoading(true);
    try {
      final response = await apiServices.forgotPasswordInit(email);

      if (response.success) {
        navigateOnSuccess();
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "An error occurred!";
        handleError(message: errorMessage);
      }
    } catch (e) {
      handleError(message: "Something went wrong.");
    } finally {
      _setLoading(false);
    }
  }
}
