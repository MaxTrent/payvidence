// import 'dart:convert';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:payvidence/data/api_layer.dart';
// import 'package:payvidence/model/login_model.dart';
// import 'package:payvidence/model/verify_otp_model.dart';
// import '../model/create_account_model.dart';
// import '../utilities/api_status_response.dart';
// import '../utilities/payvidence_endpoints.dart';
// import '../utilities/app_logger.dart';
//
// final apiServiceProvider = Provider((ref) => ApiServices());
//
// class ApiServices {
//   Future<T> _makeRequest<T>({
//     required String endpoint,
//     required HttpMethod method,
//     required T Function(Map<String, dynamic>) parser,
//     Map<String, dynamic>? body,
//     Map<String, String>? headers,
//     bool requireAuth = false,
//   }) async {
//     try {
//       AppUtils.debug('Initiating $method request to $endpoint');
//       final response = await ApiLayer.makeApiCall(
//         endpoint,
//         method: method,
//         body: body,
//         headers: headers,
//         requireAccess: requireAuth,
//       );
//
//       if (response is Success) {
//         AppUtils.debug('Response type: ${response.runtimeType}');
//         final data = jsonDecode(response.body);
//         AppUtils.debug('Data type after decode: ${data.runtimeType}');
//         final result = parser(data);
//         AppUtils.debug('Result type: ${result.runtimeType}');
//         return result;
//       }
//       if (response is Failure) {
//         final errorData = jsonDecode(response.errorResponse);
//         _showErrorToast(errorData['message']);
//         throw ApiException(response.statusCode, errorData['message']);
//       }
//
//       throw ApiException(0, 'Unknown response type');
//     } on ApiException catch (e) {
//       AppUtils.debug('API Error: ${e.statusCode} - ${e.message}');
//       rethrow;
//     } catch (e, stack) {
//       AppUtils.debug('Unexpected error: $e\n$stack');
//       _showErrorToast('An unexpected error occurred');
//       throw ApiException(0, e.toString());
//     }
//   }
//
//   void _showSuccessToast(String message) {
//     Fluttertoast.showToast(msg: message);
//     AppUtils.debug('Success: $message');
//   }
//
//   void _showErrorToast(String message) {
//     Fluttertoast.showToast(msg: message);
//     AppUtils.debug('Error: $message');
//   }
//
//   Future<CreateAccountModel> createAccount({
//     required String firstName,
//     required String lastName,
//     required String phone,
//     required String email,
//     required String password,
//     required String passwordConfirm,
//   }) async {
//     return _makeRequest(
//       endpoint: ApiUrls.createAccount,
//       method: HttpMethod.post,
//       parser: CreateAccountModel.fromJson,
//       body: {
//         "first_name": firstName,
//         "last_name": lastName,
//         "phone_number": phone,
//         "email": email,
//         "password": password,
//         "password_confirmation": passwordConfirm
//       },
//     );
//   }
//
//   Future<VerifyOtpModel> verifyOtp(String otp) async {
//     return _makeRequest(
//       endpoint: ApiUrls.verifyOtp,
//       method: HttpMethod.post,
//       parser: VerifyOtpModel.fromJson,
//       body: {"otp": otp},
//     );
//   }
//
//   Future<void> resendOtp() async {
//     await _makeRequest<void>(
//       endpoint: ApiUrls.resendOtp,
//       method: HttpMethod.post,
//       parser: (_) {},
//     );
//   }
//
//   Future<LoginModel> login(
//       {required String email,
//       required String password,
//       required String deviceName}) async {
//     return _makeRequest(
//         endpoint: ApiUrls.login,
//         method: HttpMethod.post,
//         parser: (data)=> LoginModel.fromJson(data),
//         body: {
//           "email": email,
//           "password": password,
//           "device_name": deviceName
//         });
//   }
// }


import 'package:payvidence/utilities/payvidence_endpoints.dart';

import '../screens/device_info.dart';
import '../shared_dependency/shared_dependency.dart';
import 'network/api_response.dart';
import 'network/network_service.dart';

class ApiServices{
  ApiServices(): super();

  Future<ApiResult> createAccount({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    var requestData = {
              "first_name": firstName,
        "last_name": lastName,
        "phone_number": phone,
        "email": email,
        "password": password,
        "password_confirmation": passwordConfirm
    };

    var response = await locator<NetworkService>().post(
        PayvidenceEndpoints.createAccount,
        data: requestData,
        useToken: false);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> login(
    String email, String password
  ) async {
    final deviceName = await getDeviceName();

    var requestData = {
      "email": email,
      "password": password,
      "device_name": deviceName
    };

    var response = await locator<NetworkService>().post(
       PayvidenceEndpoints.login,
        data: requestData,
        useToken: false);

    return ApiResult.fromJson(response);
  }


  Future<ApiResult> resendOtp() async {

    var response = await locator<NetworkService>().post(
        PayvidenceEndpoints.resendOtp,
        useToken: false);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> verifyOtp(String otp) async {

    var requestData = {
      "otp": otp,
    };

    var response = await locator<NetworkService>().post(
        PayvidenceEndpoints.verifyOtp,
        data: requestData,
        useToken: false);

    return ApiResult.fromJson(response);
  }


  // Future<ApiResult> fetchRiderProfile() async {
  //   var response = await locator<NetworkService>().get(RiderApiEndpoints.fetchRiderProfile);
  //
  //   return ApiResult.fromJson(response);
  // }

  // Future<void> fetchRiderInformation(
  //     {bool executeWithProgressIndicator = true}) async {
  //   try {
  //     if (executeWithProgressIndicator) {
  //       dialogHandler.showGlobalProgressIndicator();
  //     }
  //
  //     final response = await accountRepository.fetchRiderProfile();
  //
  //     if (response.success) {
  //       dialogHandler.dismissDialog();
  //
  //       riderInfo = Rider.fromJson(response.data!["results"]);
  //
  //       notifyListeners();
  //     } else {
  //       dialogHandler.dismissDialog();
  //
  //       var errorMessage = response.error?.errors?.first.message ??
  //           response.error?.message ??
  //           "An error occurred!";
  //       handleError(message: errorMessage);
  //     }
  //   } catch (e) {
  //     dialogHandler.dismissDialog();
  //   }
  // }

}
