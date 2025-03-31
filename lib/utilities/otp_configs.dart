// // lib/screens/otp/otp_configs.dart
// import 'package:flutter/material.dart';
// import 'package:payvidence/screens/otp/otp_vm.dart';
// import 'package:payvidence/shared_dependency/shared_dependency.dart';
// import 'package:payvidence/data/local/session_constants.dart';
//
// class OtpConfigs {
//   static final Map<String, OtpConfig> _configs = {
//     'account_verification': OtpConfig(
//       purpose: 'account_verification',
//       verifyOtp: (otp, context) async {
//         final apiServices = locator<ApiServices>();
//         final sessionManager = locator<SessionManager>();
//         final userId = sessionManager.get(SessionConstants.userId);
//         final response = await apiServices.verifyOtp(otp, userId);
//         if (!response.success) {
//           final errorMessage = response.error?.errors?.first.message ??
//               response.error?.message ??
//               "An error occurred!";
//           locator<DialogHandler>().showCustomTopToastDialog(
//             context: context,
//             message: errorMessage,
//             toastMessageType: ToastMessageType.failure,
//           );
//         }
//         return response.success;
//       },
//       resendOtp: (context) async {
//         final apiServices = locator<ApiServices>();
//         final sessionManager = locator<SessionManager>();
//         final userId = sessionManager.get(SessionConstants.userId);
//         final response = await apiServices.resendOtp(userId);
//         if (!response.success) {
//           final errorMessage = response.error?.errors?.first.message ??
//               response.error?.message ??
//               "An error occurred!";
//           locator<DialogHandler>().showCustomTopToastDialog(
//             context: context,
//             message: errorMessage,
//             toastMessageType: ToastMessageType.failure,
//           );
//         }
//       },
//     ),
//     'password_reset': OtpConfig(
//       purpose: 'password_reset',
//       verifyOtp: (otp, context) async {
//         final apiServices = locator<ApiServices>();
//         final sessionManager = locator<SessionManager>();
//         final userId = sessionManager.get(SessionConstants.userId);
//         final response = await apiServices.forgotPasswordComplete(
//           sessionManager.get(SessionConstants.tempPassword) ?? "newPassword",
//           sessionManager.get(SessionConstants.tempPasswordConfirm) ?? "newPassword",
//           userId,
//         );
//         if (!response.success) {
//           final errorMessage = response.error?.errors?.first.message ??
//               response.error?.message ??
//               "An error occurred!";
//           locator<DialogHandler>().showCustomTopToastDialog(
//             context: context,
//             message: errorMessage,
//             toastMessageType: ToastMessageType.failure,
//           );
//         }
//         return response.success;
//       },
//       resendOtp: (context) async {
//         final apiServices = locator<ApiServices>();
//         final sessionManager = locator<SessionManager>();
//         final email = sessionManager.get(SessionConstants.userEmail);
//         final response = await apiServices.forgotPasswordInit(email);
//         if (!response.success) {
//           final errorMessage = response.error?.errors?.first.message ??
//               response.error?.message ??
//               "An error occurred!";
//           locator<DialogHandler>().showCustomTopToastDialog(
//             context: context,
//             message: errorMessage,
//             toastMessageType: ToastMessageType.failure,
//           );
//         }
//       },
//     ),
//   };
//
//   static OtpConfig getConfig(String purpose) {
//     return _configs[purpose] ?? _configs['account_verification']!; // Default fallback
//   }
// }