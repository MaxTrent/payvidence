import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/cache_service.dart';
import '../../utilities/performance_monitor.dart';
import '../local/session_constants.dart';
import '../local/session_manager.dart';
import 'api_response.dart';
import 'interceptors/connection_interceptor.dart';

enum RequestMethod { get, post, patch, delete }

class NetworkService {
  final Dio dio;
  final String baseUrl;
  CacheService? _cache;

  NetworkService({required this.dio, required this.baseUrl}) {
    _initClient(baseUrl);
    try {
      _cache = locator<CacheService>();
    } catch (e) {
      _cache = null;
    }
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
        bool useCache = true,
        int? cacheTtlMinutes,
        dynamic data,
        Map<String, dynamic> headers = const {},
      }) async {
    final cacheKey = _generateCacheKey(path, data);

    // Check cache first for GET requests
    if (useCache && _cache != null) {
      final cached = _cache!.get(cacheKey);
      if (cached != null) {
        return Right(Success(cached));
      }
    }

    Map<String, dynamic> authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader(isAccessToken: isAccessToken);
    }

    final result = await request(
        requestData: data,
        headers: {...headers, ...authorizedHeader},
        path: path,
        requestMethod: RequestMethod.get);

    // Cache successful GET responses
    if (useCache && _cache != null && result.isRight()) {
      result.fold(
            (l) => null,
            (success) => _cache!.set(cacheKey, success.data, ttlMinutes: cacheTtlMinutes),
      );
    }

    return result;
  }

  Future<Either<Failure, Success>> post(
      path, {
        bool useToken = true,
        bool clearCache = true,
        dynamic data,
        Map<String, dynamic> headers = const {},
      }) async {
    Map<String, dynamic> authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader(isAccessToken: true);
    }

    final result = await request(
        requestData: data,
        headers: {...headers, ...authorizedHeader},
        path: path,
        requestMethod: RequestMethod.post);

    // Clear related cache on successful mutations
    if (clearCache && _cache != null && result.isRight()) {
      await _clearRelatedCache(path);
    }

    return result;
  }

  Future<Either<Failure, Success>> patch(
      path, {
        bool useToken = true,
        bool clearCache = true,
        dynamic data,
        Map<String, dynamic> headers = const {},
      }) async {
    Map<String, dynamic> authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader(isAccessToken: true);
    }

    final result = await request(
        requestData: data,
        headers: {...headers, ...authorizedHeader},
        path: path,
        requestMethod: RequestMethod.patch);

    if (clearCache && _cache != null && result.isRight()) {
      await _clearRelatedCache(path);
    }

    return result;
  }

  Future<Either<Failure, Success>> delete(
      String path, {
        bool useToken = true,
        bool clearCache = true,
        dynamic data,
        Map<String, dynamic> headers = const {},
      }) async {
    Map<String, dynamic> authorizedHeader = {};
    if (useToken) {
      authorizedHeader = await getAuthorizedHeader(isAccessToken: true);
    }

    final result = await request(
      requestData: data,
      headers: {...headers, ...authorizedHeader},
      path: path,
      requestMethod: RequestMethod.delete,
    );

    if (clearCache && _cache != null && result.isRight()) {
      await _clearRelatedCache(path);
    }

    return result;
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

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.unknown) {
        return Left(Failure(ApiErrorResponseV2(message: e.message)));
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

  String _generateCacheKey(String path, dynamic data) {
    return '$path${data != null ? '_${data.hashCode}' : ''}';
  }

  Future<void> _clearRelatedCache(String path) async {
    // Clear cache for related endpoints
    final segments = path.split('/');
    if (segments.isNotEmpty && _cache != null) {
      await _cache!.clear(segments.first);
    }
  }
}
