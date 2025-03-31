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
    final isBiometricEnabled = await locator<SessionManager>()
            .get(SessionConstants.isBiometricLoginEnabled) ??
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
    try {
      _isLoading = true;
      notifyListeners();
      final response = await apiServices.login(email, password);

      _isLoading = false;
      notifyListeners();

      if (response.success) {
        _isLoading = false;
        notifyListeners();

        var user = User.fromJson(response.data!["data"]);
        await saveUserCredentials(
            userId: user.account.id,
            firstName: user.account.firstName,
            lastName: user.account.lastName,
            email: user.account.email,
            phoneNumber: user.account.phoneNumber,
            profilePictureUrl: user.account.profilePictureUrl ?? "",
            token: user.token ?? "");
        await locator<SessionManager>()
            .save(key: SessionConstants.isUserLoggedIn, value: true);
        await locator<SessionManager>()
            .save(key: SessionConstants.accessTokenPref, value: user.token);
        notifyListeners();

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
      handleError(message: "An unexpected error occurred. Please try again.");
      throw Exception(e);
    }
  }

  Future<void> biometricLogin({
    required Function() navigateOnSuccess,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (!await BiometricService.canCheckBiometrics()) {
        handleError(message: "Biometric authentication is not available.");
        return;
      }

      bool authenticated = await BiometricService.authenticate(
        reason: "Login with your biometric credentials",
      );

      if (authenticated) {
        final email =
            await locator<SessionManager>().get(SessionConstants.userEmail);
        final token = await locator<SessionManager>()
            .get(SessionConstants.accessTokenPref);

        if (email != null && token != null) {
          await locator<SessionManager>()
              .save(key: SessionConstants.isUserLoggedIn, value: true);
          navigateOnSuccess();
        } else {
          handleError(
              message:
                  "No saved credentials found. Please login manually first.");
        }
      } else {
        handleError(message: "Biometric authentication failed.");
      }
    } catch (e) {
      handleError(message: "An error occurred during biometric login.");
      throw Exception(e);
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
    locator<SessionManager>().save(key: SessionConstants.userId, value: userId);

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
