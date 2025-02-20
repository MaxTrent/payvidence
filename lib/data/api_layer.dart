// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:http/http.dart' as http;
//
// import '../utilities/api_status_response.dart';
// import '../utilities/payvidence_endpoints.dart';
// import '../utilities/app_logger.dart';
// enum HttpMethod { post, put, patch, get, delete }
//
//
//
// class ApiException implements Exception {
//   final int statusCode;
//   final dynamic message;
//
//   ApiException(this.statusCode, this.message);
//
//   @override
//   String toString() {
//     return 'ApiException{statusCode: $statusCode, message: $message}';
//   }
// }
//
// class NetworkException implements Exception {
//   final String message;
//
//   NetworkException(this.message);
//
//   @override
//   String toString() => 'NetworkException: $message';
// }
//
// class ApiLayer {
//   static Future<dynamic> makeApiCall(
//       String endpoint, {
//         String baseUrl = ApiUrls.baseUrl,
//         required HttpMethod method,
//         Map<String, String>? headers,
//         Object? body,
//         bool requireAccess = false,
//         String? userAccessToken,
//       }) async {
//     try {
//       final url = Uri.https(baseUrl, endpoint);
//       final requestHeaders = _buildHeaders(requireAccess, userAccessToken, headers);
//
//       AppUtils.debug("/****API call request starts****/");
//       AppUtils.debug("URL: $url");
//       AppUtils.debug("Method: ${method.name}");
//       AppUtils.debug("Headers: $requestHeaders");
//       AppUtils.debug("Body: $body");
//
//       final response = await _sendRequest(url, method, requestHeaders, body);
//
//       AppUtils.debug("/****API call response starts****/");
//       AppUtils.debug("Status code: ${response.statusCode}");
//       AppUtils.debug("Response headers: ${response.headers}");
//       AppUtils.debug("Response body: ${response.body}");
//
//       return _handleResponse(response);
//     } on HttpException catch (e, stack) {
//       AppUtils.debug('HTTP error: $e\n$stack');
//       return Failure(0, json.encode({'message': 'Connection error: ${e.message}'}));
//     } on FormatException catch (e, stack) {
//       AppUtils.debug('Format error: $e\n$stack');
//       return Failure(0, json.encode({'message': 'Data format error: ${e.message}'}));
//     } on SocketException catch (e, stack) {
//       AppUtils.debug('Network error: $e\n$stack');
//       return Failure(0, json.encode({'message': 'Network error: Please check your internet connection'}));
//     } catch (e, stack) {
//       AppUtils.debug('Unexpected error: $e\n$stack');
//       return Failure(0, json.encode({'message': 'An unexpected error occurred: ${e.toString()}'}));
//     }
//   }
//
//   static Map<String, String> _buildHeaders(
//       bool requireAccess,
//       String? userAccessToken,
//       Map<String, String>? additionalHeaders,
//       ) {
//     final headers = requireAccess
//         ? {
//       'Authorization': 'Bearer $userAccessToken',
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Accept': 'application/json',
//     }
//         : {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     };
//
//     if (additionalHeaders != null) {
//       headers.addAll(additionalHeaders);
//     }
//     return headers;
//   }
//
//   static Future<http.Response> _sendRequest(
//       Uri url,
//       HttpMethod method,
//       Map<String, String> headers,
//       [Object? body]
//       ) async {
//     try {
//       final request = http.Request(method.name.toUpperCase(), url);
//       request.headers.addAll(headers);
//       if (body != null) {
//         request.body = json.encode(body);
//       }
//
//       final streamedResponse = await request.send().timeout(
//         const Duration(seconds: 30),
//         onTimeout: () {
//           throw TimeoutException('Request timed out');
//         },
//       );
//
//       return await http.Response.fromStream(streamedResponse);
//     } catch (e) {
//       AppUtils.debug('Error in _sendRequest: $e');
//       rethrow;
//     }
//   }
//
//   static Object _handleResponse(http.Response response) {
//     try {
//       // Try to parse response body as JSON to validate it
//       final dynamic responseBody = response.body;
//       json.decode(responseBody); // This will throw FormatException if invalid JSON
//
//       switch (response.statusCode) {
//         case 200:
//           return Success(response.statusCode, response.body);
//         case 201:
//           return Success(response.statusCode, response.body);
//         case 400:
//         case 401:
//         case 404:
//           return Failure(response.statusCode, response.body);
//         case 403:
//           return Failure(response.statusCode, json.encode({'message': 'Access denied'}));
//         case 500:
//           return Failure(response.statusCode, json.encode({'message': 'Server error'}));
//         default:
//           return Failure(response.statusCode, json.encode({'message': 'Error: ${response.statusCode}'}));
//       }
//     } on FormatException catch (e) {
//       AppUtils.debug('Invalid JSON response: $e');
//       return Failure(0, json.encode({'message': 'Invalid response format from server'}));
//     } catch (e) {
//       AppUtils.debug('Error handling response: $e');
//       return Failure(0, json.encode({'message': 'Error processing response'}));
//     }
//   }
// }