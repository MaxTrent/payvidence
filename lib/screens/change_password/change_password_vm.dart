import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';



final changePasswordViewModel = ChangeNotifierProvider((ref)=> ChangePasswordViewModel(ref));

class ChangePasswordViewModel extends BaseChangeNotifier{
  final Ref ref;
  ChangePasswordViewModel(this.ref);


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmNewPassword,
    required Function() navigateOnSuccess,
  }) async {
    _setLoading(true);
    try {
      final response = await apiServices.changePassword(oldPassword, newPassword, confirmNewPassword);

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