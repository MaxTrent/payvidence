// import 'dart:async';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:payvidence/data/local/session_constants.dart';
// import 'package:payvidence/data/local/session_manager.dart';
// import 'package:payvidence/shared_dependency/shared_dependency.dart';
// import 'package:payvidence/utilities/base_notifier.dart';
//
// final otpLoginViewModelProvider = ChangeNotifierProvider((ref) {
//   return OtpLoginViewModel(ref);
// });
//
// class OtpLoginViewModel extends BaseChangeNotifier {
//   final Ref ref;
//   OtpLoginViewModel(this.ref);
//
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//
//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }
//
//   Future<void> verifyOtp({
//     required String otp,
//     required Function() navigateOnSuccess,
//   }) async {
//     _setLoading(true);
//     try {
//       final userId = locator<SessionManager>().get(SessionConstants.userId);
//       final response = await apiServices.verifyOtp(otp, userId);
//
//       if (response.success) {
//         navigateOnSuccess();
//       } else {
//         var errorMessage = response.error?.errors?.first.message ??
//             response.error?.message ??
//             "An error occurred!";
//         handleError(message: errorMessage);
//       }
//     } catch (e) {
//       handleError(message: "Something went wrong.");
//     } finally {
//       _setLoading(false);
//     }
//   }
// }
