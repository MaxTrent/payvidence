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
    await syncUserProfile();
    notifyListeners();
  }

  Future<void> syncUserProfile() async {
    try {
      developer.log('Syncing user profile');
      final response = await apiServices.getAccount();
      if (response.success) {
        var user = User.fromJson(response.data!["data"]);
        await saveUserCredentials(
          userId: user.account.id ?? '',
          firstName: user.account.firstName,
          lastName: user.account.lastName ?? '',
          email: user.account.email ?? '',
          phoneNumber: user.account.phoneNumber ?? '',
          profilePictureUrl: user.account.profilePictureUrl ?? "",
          token: user.token ?? "",
          refreshToken: user.refreshToken ?? "",
        );
        developer.log('User profile synced: ${user.account.firstName} ${user.account.lastName}');
      } else {
        developer.log('Profile sync failed: ${response.error?.message}');
      }
    } catch (e) {
      developer.log('Profile sync exception: $e');
    }
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
      developer.log('Attempting login with email: $email');
      final response = await apiServices.login(email, password);

      if (response.success) {
        var user = User.fromJson(response.data!["data"]);
        developer.log('Login successful, user: ${user.account.id}');
        await saveUserCredentials(
          userId: user.account.id ?? '',
          firstName: user.account.firstName,
          lastName: user.account.lastName ?? '',
          email: user.account.email ?? '',
          phoneNumber: user.account.phoneNumber ?? '',
          profilePictureUrl: user.account.profilePictureUrl ?? "",
          token: user.token ?? "",
          refreshToken: user.refreshToken ?? "",
        );

        await locator<SessionManager>().save(key: SessionConstants.isUserLoggedIn, value: true);
        await locator<SessionManager>().save(key: SessionConstants.accessTokenPref, value: user.token);
        await locator<SessionManager>().save(key: SessionConstants.isOnboarded, value: true);

        navigateOnSuccess();
      } else {
        _errorMessage = response.error?.errors?.first.message ?? response.error?.message ?? "An error occurred!";
        developer.log('Login failed: $_errorMessage');
        handleError(message: _errorMessage);
      }
    } catch (e) {
      _errorMessage = "Something went wrong. Please try again.";
      developer.log('Login exception: $e');
      handleError(message: _errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> _refreshAccessToken(String refreshToken) async {
    try {
      developer.log('Attempting to refresh token');
      final response = await apiServices.refreshToken();
      developer.log('Refresh response: success=${response.success}, data=${response.data}');

      if (response.success && response.data?['data'] != null) {
        final newToken = response.data!['data']['access_token'] as String?;
        if (newToken != null) {
          developer.log('Token refresh successful: $newToken');
          await locator<SessionManager>().save(key: SessionConstants.accessTokenPref, value: newToken);
          return true;
        } else {
          _errorMessage = "No access token in response.";
          developer.log('Token refresh failed: $_errorMessage');
          return false;
        }
      } else {
        _errorMessage = response.error?.message ?? "Failed to refresh token.";
        developer.log('Token refresh failed: $_errorMessage');
        return false;
      }
    } catch (e) {
      _errorMessage = "Error refreshing token: $e";
      developer.log('Token refresh exception: $e');
      return false;
    }
  }

  Future<void> biometricLogin({
    required Function() navigateOnSuccess,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      developer.log('Starting biometric login');
      final result = await BiometricService.authenticate(
        reason: "Login with your biometric credentials",
      );

      if (result.success) {
        final email = locator<SessionManager>().get<String>(SessionConstants.userEmail);
        final token = locator<SessionManager>().get<String>(SessionConstants.accessTokenPref);
        final refreshToken = locator<SessionManager>().get<String>(SessionConstants.refreshToken);

        developer.log('Biometric auth success, email: $email, token: $token, refreshToken: $refreshToken');

        if (email == null || refreshToken == null) {
          _errorMessage = "No saved credentials found. Please login manually first.";
          developer.log(_errorMessage);
          handleError(message: _errorMessage);
          return;
        }

        bool refreshSuccess = await _refreshAccessToken(refreshToken);
        if (refreshSuccess) {
          developer.log('Token refreshed, proceeding with login');
          await locator<SessionManager>().save(key: SessionConstants.isUserLoggedIn, value: true);
          navigateOnSuccess();
        } else {
          _errorMessage = "Unable to refresh session. Please login manually.";
          developer.log(_errorMessage);
          handleError(message: _errorMessage);
        }
      } else {
        _errorMessage = result.errorMessage ?? "Biometric authentication failed.";
        developer.log('Biometric auth failed: $_errorMessage');
        handleError(message: _errorMessage);
      }
    } catch (e) {
      _errorMessage = "An unexpected error occurred during biometric login: $e";
      developer.log('Biometric login exception: $e');
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
    required String refreshToken,
  }) async {
    developer.log('Saving user credentials: userId=$userId, email=$email');
    await locator<SessionManager>().save(key: SessionConstants.userId, value: userId);
    await locator<SessionManager>().save(key: SessionConstants.userFirstName, value: firstName);
    await locator<SessionManager>().save(key: SessionConstants.userLastName, value: lastName);
    await locator<SessionManager>().save(key: SessionConstants.userEmail, value: email);
    await locator<SessionManager>().save(key: SessionConstants.userPhone, value: phoneNumber);
    await locator<SessionManager>().save(key: SessionConstants.profilePictureUrl, value: profilePictureUrl);
    await locator<SessionManager>().save(key: SessionConstants.accessTokenPref, value: token);
    await locator<SessionManager>().save(key: SessionConstants.refreshToken, value: refreshToken);
  }
}