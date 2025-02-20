import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';


final loginViewModelProvider =
ChangeNotifierProvider<LoginViewModel>((ref) {
  return LoginViewModel(ref);
});


class LoginViewModel extends BaseChangeNotifier {
  final Ref ref;
  LoginViewModel(this.ref);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> login({

    required String email,
    required String password,
    required Function() navigateOnSuccess,
  }) async {
    try {

      _isLoading = true;
      notifyListeners();
      final response = await apiServices.login(email, password);

      if (response.success) {
        _isLoading = false;
        notifyListeners();
        navigateOnSuccess();
      } else
        {
          _isLoading = false;
          notifyListeners();
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "An error occurred!";
        handleError(message: errorMessage);
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception(e);
    }
  }


}
