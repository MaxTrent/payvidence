import 'dart:io';
import 'package:dio/dio.dart';
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


  Future<ApiResult> resendOtp(String userId) async {

    var response = await locator<NetworkService>().post(
        PayvidenceEndpoints.resendOtp(userId),
        useToken: false);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> verifyOtp(String otp, String userId) async {

    var requestData = {
      "otp": otp,
    };

    var response = await locator<NetworkService>().post(
        PayvidenceEndpoints.verifyOtp(userId),
        data: requestData,
        useToken: false);

    return ApiResult.fromJson(response);
  }


  Future<ApiResult> forgotPasswordInit(String email) async {

    var requestData = {
      "email": email,
    };

    var response = await locator<NetworkService>().post(
        PayvidenceEndpoints.forgotPasswordInit,
        data: requestData,
        useToken: false);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> forgotPasswordComplete(String password, String confirmPassword, String userId) async {

    var requestData = {
      "password": password,
      "password_confirmation": confirmPassword,
    };

    var response = await locator<NetworkService>().post(
        PayvidenceEndpoints.forgotPasswordComplete(userId),
        data: requestData,
        useToken: false);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> getAccount() async {
    var response = await locator<NetworkService>().get(PayvidenceEndpoints.getAccount);

    return ApiResult.fromJson(response);
  }


  Future<ApiResult> getBusiness() async {
    var response = await locator<NetworkService>().get(PayvidenceEndpoints.business,

    );

    return ApiResult.fromJson(response);
  }


  Future<ApiResult> getTransactions() async {
    var response = await locator<NetworkService>().get(PayvidenceEndpoints.business,
    );

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> updateProfilePicture(
      File profilePicture
      ) async {

    var formData = FormData.fromMap({
      'profile_picture': await MultipartFile.fromFile(
        profilePicture.path,
        filename: profilePicture.path.split('/').last,
      ),
    });


    final response = await locator<NetworkService>().post(
      PayvidenceEndpoints.updateProfilePicture,
      data: formData,
      useToken: true,
    );

    return ApiResult.fromJson(response);
  }


  Future<ApiResult> resetPasswordInit(String email) async {

    var requestData = {
      "email": email,
    };

    var response = await locator<NetworkService>().post(
        PayvidenceEndpoints.resetPasswordInit,
        data: requestData,
        useToken: true);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> resetPasswordComplete(String password, String confirmPassword) async {

    var requestData = {
      "password": password,
      "password_confirmation": confirmPassword,
    };

    var response = await locator<NetworkService>().post(
        PayvidenceEndpoints.resetPasswordComplete,
        data: requestData,
        useToken: true);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> changePassword(String oldPassword, String password, String confirmPassword) async {

    var requestData = {
      "old_password": oldPassword,
      "password": password,
      "password_confirmation": confirmPassword
    };

    var response = await locator<NetworkService>().post(
        PayvidenceEndpoints.changePassword,
        data: requestData,
        useToken: true);

    return ApiResult.fromJson(response);
  }


  Future<ApiResult> getPendingSubscriptions() async {
    var requestData = {
      "status": "pending",
    };

    var response = await locator<NetworkService>().get(
      PayvidenceEndpoints.listSubscriptions,
      data: requestData,
    );

    return ApiResult.fromJson(response);
  }




  Future<ApiResult> logout() async {
    var response = await locator<NetworkService>().post(
        PayvidenceEndpoints.logout);

    return ApiResult.fromJson(response);
  }

  // Future<ApiResult> addClient(
  //     String name, String address, String phoneNumber
  //     ) async {
  //   final deviceName = await getDeviceName();
  //
  //   var requestData = {
  //     "name": "Samson Okubanjo",
  //     "address": "6, Jebba str, Yaba, Lagos",
  //     "phone_number": "09035690829"
  //   };
  //
  //   var response = await locator<NetworkService>().post(
  //       PayvidenceEndpoints.a,
  //       data: requestData,
  //       useToken: true);
  //
  //   return ApiResult.fromJson(response);
  // }

}
