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


  Future<ApiResult> getAccount() async {
    var response = await locator<NetworkService>().get(PayvidenceEndpoints.getAccount);

    return ApiResult.fromJson(response);
  }


  Future<ApiResult> getBusiness() async {
    var response = await locator<NetworkService>().get(PayvidenceEndpoints.business);

    return ApiResult.fromJson(response);
  }

  Future<ApiResult> addBusiness(
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
        useToken: true);

    return ApiResult.fromJson(response);
  }



}
