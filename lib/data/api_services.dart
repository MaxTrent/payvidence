import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:payvidence/model/create_account_model.dart';

import '../utilities/api_status_response.dart';
import '../utilities/api_urls.dart';
import '../utilities/app_utils.dart';
import 'api_layer.dart';

class ApiServices {
  Future<CreateAccountModel> createAccount(
      {required String firstName,
      required String lastName,
      required String phone,
      required String email,
      required String password,
      required String passwordConfirm}) async {
    late CreateAccountModel createAccountModel;

    try {
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

      // await SharedPreferencesHelper.storeUserEmail(email);

      if (response is Success) {
        AppUtils.debug(response.body);
        final data = json.decode(response.body);
        final message = data['message'];
        AppUtils.debug(message);
        createAccountModel = CreateAccountModel.fromJson(data);
        Fluttertoast.showToast(msg: message);
      } else if (response is Failure) {
        final data = json.decode(response.errorResponse);
        final message = data['message'];
        Fluttertoast.showToast(msg: message);
      }
      return createAccountModel;
    } catch (e) {
      AppUtils.debug(e.toString());
      throw Exception(e);
    }
  }
}
