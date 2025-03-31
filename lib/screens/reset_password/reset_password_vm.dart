import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';


final resetPasswordViewModelProvider = ChangeNotifierProvider((ref)=> ResetPasswordViewModel(ref));

class ResetPasswordViewModel extends BaseChangeNotifier{
  final Ref ref;
  ResetPasswordViewModel(this.ref);


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> resetPasswordInit({
    required String email,
    required Function() navigateOnSuccess,
  }) async {
    _setLoading(true);
    try {
      final response = await apiServices.resetPasswordInit(email);

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