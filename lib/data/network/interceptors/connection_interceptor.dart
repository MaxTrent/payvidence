import 'package:dio/dio.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/data/local/session_constants.dart';
import 'package:payvidence/data/local/session_manager.dart';
import 'package:payvidence/utilities/auth_navigation_helper.dart';
import 'dart:io';
import 'dart:developer' as developer;

class ConnectionStatusInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final isConnected = await _isInternetAvailable();
    if (!isConnected) {
      handler.reject(DioException(
        requestOptions: options,
        message: "Oops! There is no internet connection!",
        type: DioExceptionType.unknown,
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
      _handleUnauthorized(err);
    }
    handler.next(err);
  }

  Future<void> _handleUnauthorized(DioException err) async {
    if (err.response?.data is Map && 
        err.response?.data['message'] == 'unauthorized') {
      developer.log('401 Unauthorized detected: ${err.requestOptions.path}');
      
      // Use the dedicated helper to handle logout and navigation
      await AuthNavigationHelper.forceLogoutAndNavigateToOnboarding();
    }
  }

  Future<bool> _isInternetAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}