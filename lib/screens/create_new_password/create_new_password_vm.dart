import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';

import '../../data/local/session_constants.dart';
import '../../data/local/session_manager.dart';
import '../../shared_dependency/shared_dependency.dart';

final createNewPasswordViewModel =
    ChangeNotifierProvider((ref) => CreateNewPasswordViewModel(ref));

class CreateNewPasswordViewModel extends BaseChangeNotifier {
  final Ref ref;
  CreateNewPasswordViewModel(this.ref);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> createNewPassword({
    required String password,
    required String confirmPassword,
    required Function() navigateOnSuccess,
  }) async {
    _setLoading(true);
    try {
      final userId = locator<SessionManager>().get<String>(SessionConstants.userId);
      final response = await apiServices.forgotPasswordComplete(
          password, confirmPassword, userId!);

      if (response.success) {
        navigateOnSuccess();
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "An error occurred!";
        handleError(message: errorMessage);
      }
    } catch (e) {
      print(e);
      handleError(message: "Something went wrong.");
    } finally {
      _setLoading(false);
    }
  }
}
