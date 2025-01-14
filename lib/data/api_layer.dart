import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../utilities/api_status_response.dart';
import '../utilities/api_urls.dart';
import '../utilities/app_utils.dart';
enum HttpMethod { post, put, patch, get, delete }

class ApiException implements Exception {
  final int statusCode;
  final dynamic message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() {
    return 'ApiException{statusCode: $statusCode, message: $message}';
  }
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class ApiLayer {

  static Future<dynamic> makeApiCall(
      String endpoint, {
        String baseUrl = ApiUrls.baseUrl,
        required HttpMethod method,
        Map<String, String>? headers,
        Object? body,
        bool requireAccess = false,
        String? userAccessToken,
      }) async {
    try {
      final url = Uri.https(baseUrl, endpoint);
      final requestHeaders =
      _buildHeaders(requireAccess, userAccessToken, headers);
      final response = await _sendRequest(url, method, requestHeaders, body);

      AppUtils.debug("/****API call response starts****/");
      AppUtils.debug("status code: ${response.statusCode}");
      AppUtils.debug("response: ${response.body}");

      return _handleResponse(response);
    } on HttpException {
      return NetWorkFailure();
    } on FormatException {
      return UnExpectedError();
    } on SocketException catch (e) {
      AppUtils.debug('Network error: $e');
      throw NetworkException(e.toString());
    } catch (e) {
      AppUtils.debug('Unexpected error: $e');
      rethrow;
    }
  }

  static Map<String, String> _buildHeaders(bool requireAccess,
      String? userAccessToken, Map<String, String>? additionalHeaders) {
    final headers = requireAccess
        ? {
      'Authorization': 'Bearer $userAccessToken',
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    }
        : {

      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    return headers;
  }


  static Future<http.Response> _sendRequest(
      Uri url, HttpMethod method, Map<String, String> headers,
      [Object? body]) async {
    final request = http.Request(method.name, url);
    request.headers.addAll(headers);
    if (body != null) {
      request.body = json.encode(body);
    }
    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }


  static Object _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return Success(response.statusCode, response.body);
      case 400:
      // return Failure(response.statusCode,
      //     defaultApiResponseFromJson(response.body).toString());
        return Failure(response.statusCode, response.body);
      case 401:
      case 403:
      case 404:
        return Failure(response.statusCode, response.body);
      case 500:
        return Failure(response.statusCode, 'Invalid Credentials');
      default:
        throw ApiException(response.statusCode, 'Error occurred');
    }

  }
}