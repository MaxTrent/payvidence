import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;


class BiometricResult {
  final bool success;


  final String? errorMessage;

  const BiometricResult({
    required this.success,
    this.errorMessage,
  });

  @override
  String toString() => 'BiometricResult(success: $success, errorMessage: $errorMessage)';
}

class BiometricService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  BiometricService._();

   static Future<bool> canCheckBiometrics() async {
    try {
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      final availableBiometrics = await getAvailableBiometrics();

      print('BiometricService: isDeviceSupported=$isDeviceSupported, '
          'availableBiometrics=$availableBiometrics');

      return isDeviceSupported && availableBiometrics.isNotEmpty;
    } catch (e, stackTrace) {
      print('BiometricService: Biometric availability check failed: $e\n$stackTrace');
      return false;
    }
  }

   static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e, stackTrace) {
      print('BiometricService: Failed to get available biometrics: $e\n$stackTrace');
      return [];
    }
  }

  static Future<BiometricResult> authenticate({
    required String reason,
    bool stickyAuth = false,
  }) async {
    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: stickyAuth,
          useErrorDialogs: true,
          sensitiveTransaction: true,
        ),
      );
      return BiometricResult(success: authenticated);
    } on PlatformException catch (e, stackTrace) {
      final errorMessage = switch (e.code) {
        auth_error.notAvailable => "Biometric authentication is not available on this device.",
        auth_error.notEnrolled => "No biometrics are enrolled. Please set up biometrics in your device settings.",
        auth_error.lockedOut => "Biometric authentication is locked out due to too many failed attempts.",
        auth_error.permanentlyLockedOut => "Biometric authentication is permanently locked out. Please use another authentication method.",
        _ => "Biometric authentication failed: ${e.message ?? 'Unknown error'}",
      };
      print('BiometricService: Biometric auth error: $errorMessage\n$stackTrace');
      return BiometricResult(success: false, errorMessage: errorMessage);
    } catch (e, stackTrace) {
      final errorMessage = "An unexpected error occurred during biometric authentication: $e";
      print('BiometricService: Biometric auth error: $errorMessage\n$stackTrace');
      return BiometricResult(success: false, errorMessage: errorMessage);
    }
  }
}