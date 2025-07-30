import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../shared_dependency/shared_dependency.dart';

import '../../utilities/performance_monitor.dart';
import '../local/session_constants.dart';
import '../local/session_manager.dart';
import 'api_response.dart';
import 'interceptors/connection_interceptor.dart';
import 'interceptors/token_refresh_interceptor.dart';

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
        receiveTimeout: const Duration(seconds: 20),
        // Add validateStatus to accept all status codes and handle them manually
        validateStatus: (status) => true);

    dio.options = options;
    
    // Bypass certificate verification in debug mode
    if (kDebugMode) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
    }
    
    // Add connection interceptor first to handle network issues and unauthorized errors
    dio.interceptors.add(ConnectionStatusInterceptor());
    
    // Add token refresh interceptor to handle token refresh
    dio.interceptors.add(TokenRefreshInterceptor(dio));

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
      authorizedHeader =
      await getAuthorizedHeader(isAccessToken: isAccessToken);
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

      // Check for error status codes
      if (response.statusCode! >= 400) {
        PerformanceMonitor.endTimer(operation);
        
        // Handle 500 errors specifically
        if (response.statusCode! == 500) {
          return Left(Failure(ApiErrorResponseV2(
            message: "Server error: Internal Server Error",
            errors: [ApiError(message: "The server encountered an error processing your request")],
          )));
        }
        
        // Handle other error responses
        if (response.data is Map<String, dynamic>) {
          return Left(Failure.fromMap(response.data as Map<String, dynamic>));
        } else if (response.data is String) {
          return Left(Failure(ApiErrorResponseV2(
            message: 'Server error: ${response.statusCode} ${response.statusMessage}',
            errors: [ApiError(message: response.statusMessage ?? 'Unknown error')],
          )));
        } else {
          return Left(Failure(ApiErrorResponseV2(
            message: 'Unexpected server response: ${response.statusCode}',
            errors: [ApiError(message: 'The server response could not be processed')],
          )));
        }
      }
      
      // Process successful response
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
        // The token refresh interceptor should have already tried to refresh the token
        // If we still get here, it means the refresh failed
        await locator<SessionManager>().save(key: SessionConstants.isUserLoggedIn, value: false);
        return Left(Failure(const ApiErrorResponseV2(
            message: 'Session expired. Please log in again.')));
      }

      // Handle different response data types
      if (e.response!.data is Map<String, dynamic>) {
        return Left(Failure.fromMap(e.response!.data as Map<String, dynamic>));
      } else if (e.response!.data is String) {
        // Handle HTML or plain text error responses
        return Left(Failure(ApiErrorResponseV2(
          message: 'Server error: ${e.response!.statusCode} ${e.response!.statusMessage}',
          errors: [ApiError(message: e.response!.statusMessage ?? 'Unknown error')],
        )));
      } else {
        // Handle other types of responses
        return Left(Failure(const ApiErrorResponseV2(
          message: 'Unexpected server response format',
          errors: [ApiError(message: 'The server response could not be processed')],
        )));
      }
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
