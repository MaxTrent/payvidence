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

  LoginViewModel(this.ref) {
    init();
  }

  bool _isLoading = false;
  bool _canUseBiometrics = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  bool get canUseBiometrics => _canUseBiometrics;
  String get errorMessage => _errorMessage;

  bool get isBiometricEnabled {
    return locator<SessionManager>().get<bool>(SessionConstants.isBiometricLoginEnabled) ?? false;
  }

  bool get shouldUseBiometricLogin => _canUseBiometrics && isBiometricEnabled;

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
          userId: user.account.id ?? '',
          firstName: user.account.firstName ?? '',
          lastName: user.account.lastName ?? '',
          email: user.account.email ?? '',
          phoneNumber: user.account.phoneNumber ?? '',
          profilePictureUrl: user.account.profilePictureUrl ?? "",
          token: user.token ?? "",
        );

        await locator<SessionManager>().save(key: SessionConstants.isUserLoggedIn, value: true);
        await locator<SessionManager>().save(key: SessionConstants.accessTokenPref, value: user.token);

        navigateOnSuccess();
      } else {
        _errorMessage = response.error?.errors?.first.message ?? response.error?.message ?? "An error occurred!";
        handleError(message: _errorMessage);
      }
    } catch (e, stackTrace) {
      developer.log(
        'Login error',
        error: e.toString(),
        stackTrace: stackTrace,
        name: 'LoginViewModel',
      );
      _errorMessage = "Something went wrong. Please try again.";
      handleError(message: _errorMessage);
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
      final result = await BiometricService.authenticate(
        reason: "Login with your biometric credentials",
      );

      if (result.success) {
        final email = locator<SessionManager>().get<String>(SessionConstants.userEmail);
        final token = locator<SessionManager>().get<String>(SessionConstants.accessTokenPref);

        if (email != null && token != null) {
          await locator<SessionManager>().save(key: SessionConstants.isUserLoggedIn, value: true);
          _errorMessage = '';
          notifyListeners();
          navigateOnSuccess();
        } else {
          _errorMessage = "No saved credentials found. Please login manually first.";
          notifyListeners();
          handleError(message: _errorMessage);
        }
      } else {
        _errorMessage = result.errorMessage ?? "Biometric authentication failed.";
        notifyListeners();
        handleError(message: _errorMessage);
      }
    } catch (e) {
      _errorMessage = "An unexpected error occurred during biometric login: $e";
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
    await locator<SessionManager>().save(key: SessionConstants.userFirstName, value: firstName);
    await locator<SessionManager>().save(key: SessionConstants.userLastName, value: lastName);
    await locator<SessionManager>().save(key: SessionConstants.userEmail, value: email);
    await locator<SessionManager>().save(key: SessionConstants.userPhone, value: phoneNumber);
    await locator<SessionManager>().save(key: SessionConstants.profilePictureUrl, value: profilePictureUrl);
    await locator<SessionManager>().save(key: SessionConstants.accessTokenPref, value: token);
  }
}