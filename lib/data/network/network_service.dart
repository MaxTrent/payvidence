import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../shared_dependency/shared_dependency.dart';
import '../local/session_constants.dart';
import '../local/session_manager.dart';
import 'api_response.dart';
import 'interceptors/connection_interceptor.dart';

enum RequestMethod { get, post, patch, delete }

class NetworkService {
  final Dio dio;
  final String baseUrl;

  NetworkService({required this.dio, required this.baseUrl}) {
    _initClient(baseUrl);
  }

  void _initClient(baseUrl) {
    final options = BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20));
    // connectTimeout: const Duration(seconds: 120),
    // receiveTimeout: const Duration(seconds: 120));

    dio.options = options;

    dio.interceptors.add(ConnectionStatusInterceptor());
    if (kDebugMode) {
      dio.interceptors
          .add(PrettyDioLogger(requestHeader: true, requestBody: true));
    }
    // dio.interceptors.add(LoggingInterceptor());
  }

  Future<Either<Failure, Success>> get(
    path, {
    bool useToken = true,
    dynamic data,
    Map<String, dynamic> headers = const {},
  }) async {
    Map<String, dynamic> authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader();
    }

    return request(
        requestData: data,
        headers: {...headers, ...authorizedHeader},
        path: path,
        requestMethod: RequestMethod.get);
  }

  Future<Either<Failure, Success>> patch(
    path, {
    bool useToken = true,
    dynamic data,
    Map<String, dynamic> headers = const {},
  }) async {
    Map<String, dynamic> authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader();
    }

    return request(
        requestData: data,
        headers: {...headers, ...authorizedHeader},
        path: path,
        requestMethod: RequestMethod.patch);
  }

  Future<Either<Failure, Success>> post(
    path, {
    bool useToken = true,
    dynamic data,
    Map<String, dynamic> headers = const {},
  }) async {
    Map<String, dynamic> authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader();
    }

    return request(
        requestData: data,
        headers: {...headers, ...authorizedHeader},
        path: path,
        requestMethod: RequestMethod.post);
  }

  Future<Either<Failure, Success>> delete(
    String path, {
    bool useToken = true,
    dynamic data,
    Map<String, dynamic> headers = const {},
  }) async {
    Map<String, dynamic> authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader();
    }

    return request(
      requestData: data,
      headers: {...headers, ...authorizedHeader},
      path: path,
      requestMethod: RequestMethod.delete,
    );
  }

  Future<Either<Failure, Success>> request({
    required dynamic requestData,
    required Map<String, dynamic> headers,
    required String path,
    required RequestMethod requestMethod,
  }) async {
    try {
      Response? response;
      switch (requestMethod) {
        case RequestMethod.get:
          response = await dio.get(
            path,
            queryParameters: requestData,
            options: Options(headers: headers),
          );
          break;
        case RequestMethod.post:
          response = await dio.post(
            path,
            data: requestData,
            options: Options(
              contentType: 'application/json',
              headers: headers,
            ),
          );
          break;
        case RequestMethod.patch:
          response = await dio.patch(
            path,
            data: requestData,
            options: Options(
              contentType: 'application/json',
              headers: headers,
            ),
          );
          break;
        case RequestMethod.delete:
          response = await dio.delete(
            path,
            data: requestData,
            options: Options(headers: headers),
          );
          break;
      }

      dynamic data;
      if (response.data is Map) {
        data = response.data as Map<dynamic, dynamic>;
      } else {
        data = response.data;
      }

      return Right(Success(data));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.unknown) {
        return Left(Failure(ApiErrorResponseV2(message: e.message)));
      }

      if (e.response == null) {
        return Left(Failure(const ApiErrorResponseV2(
            message:
                "Service unavailable at the moment. \nPlease try again later!")));
      }

      if (e.response!.statusCode == 401 &&
          e.response!.data is Map &&
          e.response!.data['message'] == 'Unauthenticated') {
        // await logOut();
        return Left(Failure(const ApiErrorResponseV2(
            message: 'Session expired. Please log in again.')));
      }

      return Left(Failure.fromMap(e.response!.data as Map<String, dynamic>));
    }
  }

  Future<Map<String, dynamic>> getAuthorizedHeader() async {
    var accessToken =
        locator<SessionManager>().get<String>(SessionConstants.accessTokenPref);

    locator<SessionManager>().get<String>(SessionConstants.accessTokenPref);
    print('token: $accessToken');
    final accessData = {
      "Authorization": "Bearer $accessToken",
    };

    return accessData;
  }

// Future<void> logOut() async {
//   await locator<SessionManager>().clear();
//
//   locator<DialogHandler>().showCustomTopToastDialog(
//     message: "Session Expired. Please log in again.",
//     toastMessageType: ToastMessageType.failure,
//   );
//
//   const String? appFlavor = String.fromEnvironment('FLUTTER_APP_FLAVOR') != ''
//       ? String.fromEnvironment('FLUTTER_APP_FLAVOR')
//       : null;
//
//   Future.microtask(() {
//     if (appFlavor == "user")
//       locator<UserAppRouter>().replaceAll([const OnboardingScreenRoute()]);
//     else
//       locator<RiderAppRouter>()
//           .replaceAll([const OnboardingScreenRoute()]);
//   });
// }
  // Future<void> logOut() async {
  //   await locator<SessionManager>().clear();
  //
  //   locator<DialogHandler>().showCustomTopToastDiaprint(
  //     message: "Session Expired. Please log in again.",
  //     toastMessageType: ToastMessageType.failure,
  //   );
  //
  //   const String? appFlavor = String.fromEnvironment('FLUTTER_APP_FLAVOR') != ''
  //       ? String.fromEnvironment('FLUTTER_APP_FLAVOR')
  //       : null;
  //
  //   Future.microtask(() {
  //     if (appFlavor == "user")
  //       locator<UserAppRouter>().replaceAll([const OnboardingScreenRoute()]);
  //     else
  //       locator<RiderAppRouter>()
  //           .replaceAll([const OnboardingScreenRoute()]);
  //   });
  // }
}
