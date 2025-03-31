import 'package:dio/dio.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'dart:io';

class ConnectionStatusInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Use lookupAddress for a faster internet check
    bool isConnected = await _isInternetAvailable();

    if (!isConnected) {
      handler.reject(DioException(
        requestOptions: options,
        message: "Oops! There is no internet connection!",
      ));
    } else {
      handler.next(options);
    }
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Redirect to the login page
      locator<PayvidenceAppRouter>()
          .pushAndPopUntil(const LoginRoute(), predicate: (_) => false);
      return;
    }
    handler.next(err);
  }

  // Use a faster method to check internet connection
  Future<bool> _isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
