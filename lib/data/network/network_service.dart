import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../shared_dependency/shared_dependency.dart';

import '../../utilities/performance_monitor.dart';
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

    dio.options = options;
    dio.interceptors.add(ConnectionStatusInterceptor());

    if (kDebugMode) {
      dio.interceptors
          .add(PrettyDioLogger(requestHeader: true, requestBody: true));
    }
  }



  Future<Either<Failure, Success>> get(
      path, {
        bool useToken = true,
        bool isAccessToken = true,
        dynamic data,
        Map<String, dynamic> headers = const {},
      }) async {
    Map<String, dynamic> authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader(isAccessToken: isAccessToken);
    }

    return await request(
        requestData: data,
        headers: {...headers, ...authorizedHeader},
        path: path,
        requestMethod: RequestMethod.get);
  }

  Future<Either<Failure, Success>> post(
      path, {
        bool useToken = true,
        dynamic data,
        Map<String, dynamic> headers = const {},
      }) async {
    Map<String, dynamic> authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader(isAccessToken: true);
    }

    return await request(
        requestData: data,
        headers: {...headers, ...authorizedHeader},
        path: path,
        requestMethod: RequestMethod.post);
  }

  Future<Either<Failure, Success>> patch(
      path, {
        bool useToken = true,
        dynamic data,
        Map<String, dynamic> headers = const {},
      }) async {
    Map<String, dynamic> authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader(isAccessToken: true);
    }

    return await request(
        requestData: data,
        headers: {...headers, ...authorizedHeader},
        path: path,
        requestMethod: RequestMethod.patch);
  }

  Future<Either<Failure, Success>> delete(
      String path, {
        bool useToken = true,
        dynamic data,
        Map<String, dynamic> headers = const {},
      }) async {
    Map<String, dynamic> authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader(isAccessToken: true);
    }

    return await request(
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
    final operation = '${requestMethod.name.toUpperCase()} $path';
    PerformanceMonitor.startTimer(operation);

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

      PerformanceMonitor.endTimer(operation);
      return Right(Success(data));
    } on DioException catch (e) {
      PerformanceMonitor.endTimer(operation);

      if (e.type == DioExceptionType.connectionTimeout) {
        return Left(Failure(const ApiErrorResponseV2(message: "Connection timeout. Please check your internet connection and try again.")));
      }
      
      if (e.type == DioExceptionType.receiveTimeout) {
        return Left(Failure(const ApiErrorResponseV2(message: "Server response timeout. Please try again.")));
      }
      
      if (e.type == DioExceptionType.unknown) {
        return Left(Failure(const ApiErrorResponseV2(message: "Network error. Please check your internet connection and try again.")));
      }

      if (e.response == null) {
        return Left(Failure(const ApiErrorResponseV2(
            message: "Service unavailable at the moment. \nPlease try again later!")));
      }

      if (e.response!.statusCode == 401 &&
          e.response!.data is Map &&
          e.response!.data['message'] == 'unauthorized') {
        await locator<SessionManager>().save(key: SessionConstants.isUserLoggedIn, value: false);
        return Left(Failure(const ApiErrorResponseV2(
            message: 'Session expired. Please log in again.')));
      }

      return Left(Failure.fromMap(e.response!.data as Map<String, dynamic>));
    }
  }

  Future<Map<String, dynamic>> getAuthorizedHeader({required bool isAccessToken}) async {
    var accessToken = locator<SessionManager>().get<String>(SessionConstants.accessTokenPref);
    var refreshToken = locator<SessionManager>().get<String>(SessionConstants.refreshToken);

    final accessData = {
      "Authorization": "Bearer ${isAccessToken ? accessToken : refreshToken}",
    };

    return accessData;
  }


}
