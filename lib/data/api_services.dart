import 'dart:io';
import 'package:dio/dio.dart';
import 'package:payvidence/utilities/payvidence_endpoints.dart';
import '../screens/device_info.dart';
import '../shared_dependency/shared_dependency.dart';
import 'network/api_response.dart';
import 'network/network_service.dart';

class ApiServices {
  ApiServices() : super();

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

  Future<ApiResult> login(String email, String password) async {
    final deviceName = await getDeviceName();

    var requestData = {
      "email": email,
      "password": password,
      "device_name": deviceName
    };

    var response = await locator<NetworkService>()
        .post(PayvidenceEndpoints.login, data: requestData, useToken: false);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> resendOtp(String userId) async {
    var response = await locator<NetworkService>()
        .post(PayvidenceEndpoints.resendOtp(userId), useToken: false);

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

  Future<ApiResult> forgotPasswordComplete(
      String password, String confirmPassword, String userId) async {
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
    var response =
        await locator<NetworkService>().get(PayvidenceEndpoints.getAccount);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> getBusiness() async {
    var response = await locator<NetworkService>().get(
      PayvidenceEndpoints.business,
    );

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> getTransactions() async {
    var response = await locator<NetworkService>().get(
      PayvidenceEndpoints.business,
    );

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> updateProfilePicture(File profilePicture) async {
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

  Future<ApiResult> resetPasswordComplete(
      String password, String confirmPassword) async {
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

  Future<ApiResult> changePassword(
      String oldPassword, String password, String confirmPassword) async {
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

  Future<ApiResult> createSubscription(String planId) async {
    var requestData = {"plan_id": planId};

    var response = await locator<NetworkService>().post(
        PayvidenceEndpoints.createSubscription,
        data: requestData,
        useToken: true);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> logout() async {
    var response =
        await locator<NetworkService>().post(PayvidenceEndpoints.logout);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> getPlans() async {
    var response =
        await locator<NetworkService>().get(PayvidenceEndpoints.getPlans);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> getOnePlan(String planId) async {
    var response = await locator<NetworkService>()
        .get(PayvidenceEndpoints.getOnePlan(planId));

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> getAllNotifications() async {
    var response = await locator<NetworkService>()
        .get(PayvidenceEndpoints.getAllNotifications);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> getAllTransactions(String businessId) async {
    var requestData = {
      "business_id": businessId,
    };

    var response = await locator<NetworkService>()
        .get(PayvidenceEndpoints.getAllTransactions, data: requestData);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> getClientInfo(String businessId, String clientId) async {
    var response = await locator<NetworkService>()
        .get(PayvidenceEndpoints.getClient(businessId, clientId));

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> deleteClient(String businessId, String clientId) async {
    var response = await locator<NetworkService>()
        .delete(PayvidenceEndpoints.deleteClient(businessId, clientId));

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> updateClient(
      String businessId, String clientId, String newName) async {
    var requestData = {
      "name": newName,
    };

    var response = await locator<NetworkService>().patch(
        PayvidenceEndpoints.updateClient(businessId, clientId),
        data: requestData);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> addClient(String name, String address, String phoneNumber,
      String businessId) async {
    var requestData = {
      "name": name,
      "address": address,
      "phone_number": phoneNumber
    };

    var response = await locator<NetworkService>().post(
        PayvidenceEndpoints.createClient(businessId),
        data: requestData,
        useToken: true);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> updateUserInfo(
      {String? firstName,
      String? lastName,
      String? phoneNumber,
      bool? transactionalAlerts,
      bool? promotionalUpdates,
      bool? securityAlerts}) async {
    var requestData = {
      "transactional_alerts": transactionalAlerts,
      "security_alerts": securityAlerts,
      "promotional_updates": promotionalUpdates,
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": phoneNumber,
    };

    var response = await locator<NetworkService>()
        .patch(PayvidenceEndpoints.updateUserInfo, data: requestData);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> getBusinessDetails(String businessId) async {
    var response = await locator<NetworkService>()
        .get(PayvidenceEndpoints.getBusiness(businessId));
    return ApiResult.fromJson(response);
  }

  Future<ApiResult> deleteBusiness(String businessId) async {
    var response = await locator<NetworkService>()
        .delete(PayvidenceEndpoints.getBusiness(businessId));

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> updateBusiness(String businessId,
      {String? address,
      String? name,
      String? phone,
      String? issuer,
      String? issuerRole,
      String? bankName,
      String? accountNumber,
      String? accountName,
      File? logo,
      File? issuerSignature}) async {
    var requestData = FormData.fromMap({
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (phone != null) 'phone_number': phone,
      if (issuer != null) 'issuer': issuer,
      if (issuerRole != null) 'issuer_role': issuerRole,
      if (logo != null) 'logo': await MultipartFile.fromFile(logo.path),
      if (issuerSignature != null)
        'issuer_signature': await MultipartFile.fromFile(issuerSignature.path),
      "_method": "PATCH",
      if (bankName != null) "bank_name": bankName,
      if (accountNumber != null) "account_number": accountNumber,
      if (accountName != null) "account_name": accountName,
    });

    var response = await locator<NetworkService>()
        .post(PayvidenceEndpoints.getBusiness(businessId), data: requestData);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> refreshToken() async {
    var response = await locator<NetworkService>()
        .get(PayvidenceEndpoints.refreshToken, isAccessToken: false);

    return ApiResult.fromJson(response);
  }

}
