import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';
import '../../data/local/session_constants.dart';
import '../../data/local/session_manager.dart';
import '../../model/user_model.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/biometric_service.dart';

final loginViewModelProvider = ChangeNotifierProvider<LoginViewModel>((ref) {
  return LoginViewModel(ref);
});

class LoginViewModel extends BaseChangeNotifier {
  final Ref ref;

  LoginViewModel(this.ref);

  bool _isLoading = false;
  bool _canUseBiometrics = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;

  Future<bool> get canUseBiometrics async {
    final isBiometricEnabled = locator<SessionManager>()
        .get<bool>(SessionConstants.isBiometricLoginEnabled) ??
        false;
    return _canUseBiometrics && isBiometricEnabled;
  }

  String get errorMessage => _errorMessage;

  void init() async {
    _canUseBiometrics = await BiometricService.canCheckBiometrics();
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
    required Function() navigateOnSuccess,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await apiServices.login(email, password);

      if (response.success) {
        var user = User.fromJson(response.data!["data"]);
        await saveUserCredentials(
          userId: user.account.id,
          firstName: user.account.firstName,
          lastName: user.account.lastName,
          email: user.account.email,
          phoneNumber: user.account.phoneNumber,
          profilePictureUrl: user.account.profilePictureUrl ?? "",
          token: user.token ?? "",
        );

        await locator<SessionManager>().save(key: SessionConstants.isUserLoggedIn, value: true);
        await locator<SessionManager>().save(key: SessionConstants.accessTokenPref, value: user.token);

        navigateOnSuccess();
      } else {
        var errorMessage = response.error?.errors?.first.message ?? response.error?.message ?? "An error occurred!";
        _errorMessage = errorMessage;
        notifyListeners();
        handleError(message: errorMessage);
      }
    } catch (e, stackTrace) {
      print(e.toString());
      developer.log(
          'Login error',
          error: e.toString(),
          stackTrace: stackTrace,
          name: 'LoginViewModel'
      );
      _errorMessage = "Something went wrong. Please try again.";
      notifyListeners();
      handleError(message: "Something went wrong. Please try again.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> biometricLogin({
    required Function() navigateOnSuccess,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      if (!await BiometricService.canCheckBiometrics()) {
        _errorMessage = "Biometric authentication is not available.";
        notifyListeners();
        handleError(message: _errorMessage);
        return;
      }

      bool authenticated = await BiometricService.authenticate(
        reason: "Login with your biometric credentials",
      );

      if (authenticated) {
        final email = await locator<SessionManager>().get<String>(SessionConstants.userEmail);
        final token = await locator<SessionManager>().get(SessionConstants.accessTokenPref);

        if (email != null && token != null) {
          await locator<SessionManager>().save(key: SessionConstants.isUserLoggedIn, value: true);
          navigateOnSuccess();
        } else {
          _errorMessage = "No saved credentials found. Please login manually first.";
          notifyListeners();
          handleError(message: _errorMessage);
        }
      } else {
        _errorMessage = "Biometric authentication failed.";
        notifyListeners(); // Update UI with error before handleError
        handleError(message: _errorMessage);
      }
    } catch (e) {
      _errorMessage = "An error occurred during biometric login.";
      notifyListeners();
      handleError(message: _errorMessage);
    } finally {
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
    required String profilePictureUrl,
    required String token,
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

    await locator<SessionManager>().save(
        key: SessionConstants.profilePictureUrl, value: profilePictureUrl);

    await locator<SessionManager>()
        .save(key: SessionConstants.accessTokenPref, value: token);
  }
}