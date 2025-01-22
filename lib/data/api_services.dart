import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payvidence/model/create_account_model.dart';

import '../utilities/api_status_response.dart';
import '../utilities/api_urls.dart';
import '../utilities/app_utils.dart';
import 'api_layer.dart';

final apiServiceProvider = Provider((ref) => ApiServices());

class ApiServices {



  Future<CreateAccountModel> createAccount({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      AppUtils.debug('Making API call with body: {first_name: $firstName, last_name: $lastName, phone_number: $phone, email: $email}');

      final response = await ApiLayer.makeApiCall(
        ApiUrls.createAccount,
        method: HttpMethod.post,
        body: {
          "first_name": firstName,
          "last_name": lastName,
          "phone_number": phone,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirm
        },
      );

      // Log the response type and content
      AppUtils.debug('Response type: ${response.runtimeType}');
      AppUtils.debug('Raw response: $response');

      if (response is Success) {
        AppUtils.debug('Success response body: ${response.body}');
        final data = json.decode(response.body);
        final message = data['message'];
        AppUtils.debug('Success message: $message');
        Fluttertoast.showToast(msg: message);
        return CreateAccountModel.fromJson(data);
      } else if (response is Failure) {
        AppUtils.debug('Failure response: ${response.errorResponse}');
        final data = json.decode(response.errorResponse);
        final message = data['message'] ?? 'An error occurred';
        AppUtils.debug('Failure message: $message');
        Fluttertoast.showToast(msg: message);
        throw Exception(message);
      } else if (response is UnexpectedError) {
        AppUtils.debug('UnExpectedError details: ${response.toString()}');
        AppUtils.debug('UnExpectedError message: ${response.message}');
        // AppUtils.debug('UnExpectedError stackTrace: ${response.stackTrace}');
        final message = response.message ?? 'An unexpected error occurred';
        Fluttertoast.showToast(msg: message);
        throw Exception(message);
      }

      AppUtils.debug('Unknown response type received');
      throw Exception('Unknown error occurred');

    } catch (e, stackTrace) {
      AppUtils.debug('Caught error: ${e.toString()}');
      AppUtils.debug('Stack trace: $stackTrace');
      final errorMessage = e.toString();
      Fluttertoast.showToast(msg: errorMessage);
      throw Exception(errorMessage);
    }
  }


  // Future<CreateAccountModel> createAccount(
  //     {required String firstName,
  //     required String lastName,
  //     required String phone,
  //     required String email,
  //     required String password,
  //     required String passwordConfirm}) async {
  //   late CreateAccountModel createAccountModel;
  //
  //   try {
  //     final response = await ApiLayer.makeApiCall(
  //       ApiUrls.createAccount,
  //       method: HttpMethod.post,
  //       body: {
  //         "first_name": firstName,
  //         "last_name": lastName,
  //         "phone_number": phone,
  //         "email": email,
  //         "password": password,
  //         "password_confirmation": passwordConfirm
  //       },
  //     );
  //
  //     // await SharedPreferencesHelper.storeUserEmail(email);
  //
  //     if (response is Success) {
  //       AppUtils.debug('response body: ${response.body}');
  //       final data = json.decode(response.body);
  //       final message = data['message'];
  //       AppUtils.debug('message: $message');
  //       createAccountModel = CreateAccountModel.fromJson(data);
  //       Fluttertoast.showToast(msg: message);
  //     } else if (response is Failure) {
  //       final data = json.decode(response.errorResponse);
  //       final message = data['message'];
  //       Fluttertoast.showToast(msg: message);
  //     }
  //     return createAccountModel;
  //   } catch (e) {
  //     AppUtils.debug('error: ${e.toString()}');
  //     throw Exception(e);
  //   }
  // }
}
