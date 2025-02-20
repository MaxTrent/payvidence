import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionStatusInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!await InternetConnectionChecker.instance.hasConnection) {
      handler.reject(DioException(
          requestOptions: options,
          message: "Oops! There is no internet connection!"));
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
    handler.next(err);
  }
}
