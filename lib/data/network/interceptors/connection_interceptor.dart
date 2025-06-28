import 'package:dio/dio.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'dart:io';

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
      _handleUnauthorized();
    }
    handler.next(err);
  }

  Future<void> _handleUnauthorized() async {
    final router = locator<PayvidenceAppRouter>();
    final current = router.current.name;

    // Prevent redirect loop
    if (current != 'LoginRoute' && current != 'LoginRouteWrapper') {
      Future.microtask(() {
        router.replaceAll([const LoginRoute()]);
      });
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