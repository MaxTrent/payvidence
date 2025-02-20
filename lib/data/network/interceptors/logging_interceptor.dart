
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {

  final int _maxCharactersPerLine = 200;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print("⏫ ⏫ --> ${options.method} ${options.path}");
      print("Uri -> ${options.uri}");
      print("Content type: ${options.contentType}");
      print("Headers: ${options.headers}");
      print("Body Params: ${json.encode(options.data)}");
      print("--> OUT HTTP ⏫ ⏫");
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    String responseAsString = response.data.toString();
    if(responseAsString.length > _maxCharactersPerLine) {
      int iterations = (responseAsString.length/ _maxCharactersPerLine).floor();
      var builtResponse = "";
      for(int i = 0; i < iterations; i++) {
        int endingIndex = i * _maxCharactersPerLine + _maxCharactersPerLine;
        if(endingIndex > responseAsString.length) {
          endingIndex = responseAsString.length;
        }

        builtResponse +=
            responseAsString.substring(i * _maxCharactersPerLine, endingIndex) +
                "\n";
      }

      logResponse(response, builtResponse);
    } else {
      logResponse(response, response.data.toString());
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print("❌ ❌ <------ ON ERROR --------> ❌ ❌");
      print(err.requestOptions.path);
      print(err.error);
      print(err.message);
      if (err.response != null) {
        print(err.response?.data);
      }
      print("❌ ❌ <------ END ERROR --------> ❌ ❌");
    }
    return handler.next(err);
  }

  void logResponse(Response<dynamic> response, String builtResponse) {
    debugPrint(
        "~~~~~~~~~~~~~> ${response.statusCode} ${response.requestOptions.uri} (${response.requestOptions.method})\n"
            "$builtResponse"
            "<~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ END RESPONSE");
  }

}