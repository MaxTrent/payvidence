
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';

import '../../model/user_model.dart';


final createAccountViewModelProvider =
ChangeNotifierProvider<CreateAccountViewModel>((ref) {
  return CreateAccountViewModel(ref);
});


class CreateAccountViewModel extends BaseChangeNotifier{
  final Ref ref;
  CreateAccountViewModel(this.ref);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> createAccount({
  required String firstName,
  required String lastName,
  required String phone,
  required String email,
  required String password,
  required String passwordConfirm,
    required Function() navigateOnSuccess,
  }) async {
    try {

      _isLoading = true;
      notifyListeners();
      final response = await apiServices.createAccount(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          email: email,
          password: password,
          passwordConfirm: passwordConfirm,
      );

      if (response.success) {
        _isLoading = false;
        notifyListeners();
        var user = User.fromJson(response.data!["data"]);
        // saveUserCredentials(
        //     firstName: user.account.firstName,
        //     lastName: user.account.lastName,
        //     email: user.account.email,
        //     phoneNumber: user.account.phoneNumber,
        //     profilePictureUrl: user.account.profilePictureUrl ?? "",
        //     token: user.token ?? ""
        // );

        navigateOnSuccess();

      } else {
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
  }}


