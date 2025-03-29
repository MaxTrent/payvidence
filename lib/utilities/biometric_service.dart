// import 'package:local_auth/local_auth.dart';
// import 'package:payvidence/shared_dependency/shared_dependency.dart';
//
// class BiometricService {
//   final LocalAuthentication _localAuth = LocalAuthentication();
//
//   static final BiometricService _instance = BiometricService._internal();
//   factory BiometricService() => _instance;
//   BiometricService._internal();
//
//   Future<bool> canCheckBiometrics() async {
//     return await _localAuth.canCheckBiometrics;
//   }
//
//   Future<bool> authenticate({required String reason}) async {
//     try {
//       final bool didAuthenticate = await _localAuth.authenticate(
//         localizedReason: reason,
//         options: const AuthenticationOptions(
//           biometricOnly: true, // Enforce biometrics, no fallback to PIN/password
//           stickyAuth: true, // Persist auth across app restarts if possible
//         ),
//       );
//       return didAuthenticate;
//     } catch (e) {
//       print('Biometric auth error: $e');
//       return false;
//     }
//   }
// }
//
// void registerBiometricService() {
//   }