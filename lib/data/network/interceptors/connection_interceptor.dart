import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/toast_service.dart';

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

    if (err.response?.statusCode == 401) {
      // Redirect to the login page
      locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.login);
      //ToastService.error(locator<PayvidenceAppRouter>().navigatorKey.currentContext, "Session expired, login again!");
      return;
    }
    handler.next(err);
  }
}
