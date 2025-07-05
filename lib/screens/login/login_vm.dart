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
  bool _hasSavedEmail = false;

  bool get isLoading => _isLoading;
  bool get canUseBiometrics => _canUseBiometrics;
  String get errorMessage => _errorMessage;
  bool get hasSavedEmail => _hasSavedEmail;

  bool get isBiometricEnabled {
    return locator<SessionManager>().get<bool>(SessionConstants.isBiometricLoginEnabled) ?? false;
  }

  bool get shouldUseBiometricLogin => _canUseBiometrics && isBiometricEnabled;

  void init() async {
    _canUseBiometrics = await BiometricService.canCheckBiometrics();
    await syncUserProfile();
    await _checkSavedEmail();
    notifyListeners();
  }

  Future<void> _checkSavedEmail() async {
    final savedEmail = await loadSavedEmail();
    _hasSavedEmail = savedEmail != null && savedEmail.isNotEmpty;
  }

  Future<String?> loadSavedEmail() async {
    // Prioritize signup email over saved login email
    final signupEmail = locator<SessionManager>().get<String>(SessionConstants.signupEmail);
    if (signupEmail != null && signupEmail.isNotEmpty) {
      // Clear signup email after using it once
      await locator<SessionManager>().remove(SessionConstants.signupEmail);
      return signupEmail;
    }
    return locator<SessionManager>().get<String>(SessionConstants.savedLoginEmail);
  }

  Future<void> saveEmailForNextLogin(String email) async {
    await locator<SessionManager>().save(key: SessionConstants.savedLoginEmail, value: email);
    _hasSavedEmail = true;
    notifyListeners();
  }

  Future<void> clearSavedEmail() async {
    await locator<SessionManager>().remove(SessionConstants.savedLoginEmail);
    _hasSavedEmail = false;
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

        // Save user credentials
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

        // Save email for next login
        await saveEmailForNextLogin(email);

        await locator<SessionManager>().save(key: SessionConstants.isUserLoggedIn, value: true);
        await locator<SessionManager>().save(key: SessionConstants.accessTokenPref, value: user.token);
        await locator<SessionManager>().save(key: SessionConstants.isOnboarded, value: true);

        navigateOnSuccess();
      } else {
        final detailedError = response.error?.errors?.first.message ?? response.error?.message ?? "An error occurred!";
        developer.log('Login failed: $detailedError');

        if (detailedError.toLowerCase().contains('password') &&
            detailedError.toLowerCase().contains('uppercase') &&
            detailedError.toLowerCase().contains('lowercase') &&
            detailedError.toLowerCase().contains('number') &&
            detailedError.toLowerCase().contains('special character')) {
          _errorMessage = "Incorrect credentials";
        } else {
          _errorMessage = detailedError;
        }

        handleError(message: _errorMessage);
      }
    } catch (e) {
      if (e.toString().contains('DioExceptionType.unknown')) {
        _errorMessage = "Network error. Please check your internet connection and try again.";
      } else if (e.toString().contains('DioExceptionType.connectionTimeout')) {
        _errorMessage = "Connection timeout. Please try again.";
      } else if (e.toString().contains('DioExceptionType.receiveTimeout')) {
        _errorMessage = "Server response timeout. Please try again.";
      } else {
        _errorMessage = "Something went wrong. Please try again.";
      }
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
      
      // Validate refresh token before making the call
      if (refreshToken.isEmpty) {
        _errorMessage = "Invalid refresh token.";
        developer.log('Token refresh failed: $_errorMessage');
        return false;
      }

      final response = await apiServices.refreshToken();
      developer.log('Refresh response: success=${response.success}, data=${response.data}');

      if (response.success && response.data?['data'] != null) {
        final newToken = response.data!['data']['access_token'] as String?;
        final newRefreshToken = response.data!['data']['refresh_token'] as String?;
        
        if (newToken != null && newToken.isNotEmpty) {
          developer.log('Token refresh successful');
          await locator<SessionManager>().save(key: SessionConstants.accessTokenPref, value: newToken);
          
          // Update refresh token if provided
          if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
            await locator<SessionManager>().save(key: SessionConstants.refreshToken, value: newRefreshToken);
            developer.log('Refresh token also updated');
          }
          
          return true;
        } else {
          _errorMessage = "Invalid token received from server.";
          developer.log('Token refresh failed: $_errorMessage');
          return false;
        }
      } else {
        // Handle specific error cases
        final errorMsg = response.error?.message ?? "Failed to refresh token.";
        if (errorMsg.toLowerCase().contains('expired') || errorMsg.toLowerCase().contains('invalid')) {
          _errorMessage = "Session expired. Please login again.";
        } else if (errorMsg.toLowerCase().contains('network') || errorMsg.toLowerCase().contains('connection')) {
          _errorMessage = "Network error. Please check your connection.";
        } else {
          _errorMessage = "Unable to refresh session. Please login again.";
        }
        developer.log('Token refresh failed: $_errorMessage');
        return false;
      }
    } catch (e) {
      // Handle different types of exceptions
      if (e.toString().contains('DioExceptionType.connectionTimeout') || 
          e.toString().contains('DioExceptionType.receiveTimeout')) {
        _errorMessage = "Connection timeout. Please try again.";
      } else if (e.toString().contains('DioExceptionType.unknown') || 
                 e.toString().contains('network')) {
        _errorMessage = "Network error. Please check your internet connection.";
      } else {
        _errorMessage = "Unable to refresh session. Please login again.";
      }
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
      
      // Check if biometrics are still available
      final canUseBiometrics = await BiometricService.canCheckBiometrics();
      if (!canUseBiometrics) {
        _errorMessage = "Biometric authentication is no longer available. Please use email/password login.";
        developer.log(_errorMessage);
        handleError(message: _errorMessage);
        return;
      }

      final result = await BiometricService.authenticate(
        reason: "Login with your biometric credentials",
        stickyAuth: true,
      );

      if (result.success) {
        final email = locator<SessionManager>().get<String>(SessionConstants.userEmail);
        final token = locator<SessionManager>().get<String>(SessionConstants.accessTokenPref);
        final refreshToken = locator<SessionManager>().get<String>(SessionConstants.refreshToken);
        final userId = locator<SessionManager>().get<String>(SessionConstants.userId);

        developer.log('Biometric auth success, email: $email, userId: $userId, hasToken: ${token != null}, hasRefreshToken: ${refreshToken != null}');

        // Validate required credentials
        if (email == null || email.isEmpty) {
          _errorMessage = "No saved email found. Please login manually first.";
          developer.log(_errorMessage);
          handleError(message: _errorMessage);
          return;
        }

        if (refreshToken == null || refreshToken.isEmpty) {
          _errorMessage = "No saved session found. Please login manually first.";
          developer.log(_errorMessage);
          handleError(message: _errorMessage);
          return;
        }

        if (userId == null || userId.isEmpty) {
          _errorMessage = "User session is incomplete. Please login manually first.";
          developer.log(_errorMessage);
          handleError(message: _errorMessage);
          return;
        }

        // Try to refresh the token
        bool refreshSuccess = await _refreshAccessToken(refreshToken);
        if (refreshSuccess) {
          developer.log('Token refreshed successfully, proceeding with login');
          await locator<SessionManager>().save(key: SessionConstants.isUserLoggedIn, value: true);
          
          // Sync user profile to ensure data is up to date
          try {
            await syncUserProfile();
          } catch (e) {
            developer.log('Profile sync failed during biometric login: $e');
            // Continue with login even if profile sync fails
          }
          
          navigateOnSuccess();
        } else {
          _errorMessage = "Session expired. Please login with email/password.";
          developer.log(_errorMessage);
          handleError(message: _errorMessage);
        }
      } else {
        // Handle specific biometric authentication failures
        if (result.errorMessage?.contains('cancelled') == true) {
          _errorMessage = "Authentication was cancelled.";
        } else if (result.errorMessage?.contains('locked') == true) {
          _errorMessage = result.errorMessage ?? "Biometric authentication is locked.";
        } else {
          _errorMessage = result.errorMessage ?? "Biometric authentication failed.";
        }
        developer.log('Biometric auth failed: $_errorMessage');
        handleError(message: _errorMessage);
      }
    } catch (e) {
      if (e.toString().contains('network') || e.toString().contains('connection')) {
        _errorMessage = "Network error. Please check your internet connection.";
      } else {
        _errorMessage = "An unexpected error occurred. Please try again.";
      }
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