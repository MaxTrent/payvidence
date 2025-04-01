import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';

import '../../data/local/session_constants.dart';
import '../../data/local/session_manager.dart';
import '../../model/user_model.dart';
import '../../shared_dependency/shared_dependency.dart';

final createAccountViewModelProvider =
    ChangeNotifierProvider<CreateAccountViewModel>((ref) {
  return CreateAccountViewModel(ref);
});

class CreateAccountViewModel extends BaseChangeNotifier {
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
        var user = User.fromJson(response.data!["data"]);
        saveUserCredentials(
            userId: user.account.id,
            firstName: user.account.firstName,
            lastName: user.account.lastName,
            email: user.account.email,
            phoneNumber: user.account.phoneNumber,
            // token: user.token ?? ""
        );
        final retrievedUserId = locator<SessionManager>().get<String>(SessionConstants.userId);
        print("After saveUserCredentials, retrieved User ID: $retrievedUserId");
        // await Future.delayed(Duration(milliseconds: 100)); // Ensure write completion
        final finalCheck = locator<SessionManager>().get<String>(SessionConstants.userId);
        print("Before navigation, final User ID check: $finalCheck");
        navigateOnSuccess();
        await Future.delayed(Duration(milliseconds: 1000)); // Extended delay for clarity
        final postNav = locator<SessionManager>().get<String>(SessionConstants.userId);
        print("Post-navigation User ID in CreateAccountViewModel: $postNav");
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "An error occurred!";
        handleError(message: errorMessage);
      }
    } catch (e) {
      handleError(message: "Something went wrong. Please try again.");
      debugPrint("Error: ${e.toString()}");
    }
    finally {
      _isLoading = false;
      notifyListeners();
    }

}

  Future<void> saveUserCredentials({
    required String userId,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    // required String profilePictureUrl,
    // required String token,
  }) async {
    await locator<SessionManager>().save(key: SessionConstants.userId, value: userId);

    await locator<SessionManager>()
        .save(key: SessionConstants.userFirstName, value: firstName);

    await locator<SessionManager>()
        .save(key: SessionConstants.userLastName, value: lastName);

    await locator<SessionManager>()
        .save(key: SessionConstants.userEmail, value: email);

    await locator<SessionManager>()
        .save(key: SessionConstants.userPhone, value: phoneNumber);

    // await locator<SessionManager>().save(
    //     key: SessionConstants.profilePictureUrl, value: profilePictureUrl);

    // await locator<SessionManager>()
    //     .save(key: SessionConstants.accessTokenPref, value: token);
  }
}
