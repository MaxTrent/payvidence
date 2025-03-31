import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

abstract class ApiResponse {}

class ApiResult<T> extends Equatable {
  final bool success;
  final ApiErrorResponseV2? error;
  final Map? data;

  const ApiResult({
    this.success = false,
    this.error,
    this.data,
  });

  factory ApiResult.fromJson(Either<Failure, Success> json) {
    return json.fold(
      (failure) => ApiResult(
        error: failure.error,
      ),
      (success) => ApiResult(
        success: true,
        data: success.data,
      ),
    );
  }

  @override
  List<Object?> get props => [success, error, data];
}

class Success extends ApiResponse with EquatableMixin {
  final Map<String, dynamic> data;

  Success(this.data);

  @override
  List<Object?> get props => [data];
}

class Failure extends ApiResponse with EquatableMixin {
  final ApiErrorResponseV2 error;

  Failure(this.error);

  factory Failure.fromMap(Map<String, dynamic> json) {
    return Failure(
        ApiErrorResponseV2.fromMap(json["message"], json["results"]));
  }

  @override
  List<Object?> get props => [error];
}

enum ApiErrorType { unknown }

class ApiErrorResponseV2 extends Equatable {
  final String? message;

  final List<ApiError>? errors;

  const ApiErrorResponseV2({this.message, this.errors});

  factory ApiErrorResponseV2.fromMap(
      String message, Map<String, dynamic>? json) {
    var apiErrors = json?["errors"] as List?;

    List<ApiError>? errors =
        apiErrors?.map((e) => ApiError.fromMap(e)).toList();

    return ApiErrorResponseV2(message: message, errors: errors);
  }

  @override
  List<Object?> get props => [message, props];
}

class ApiErrorResponse extends Equatable {
  final List<ApiError>? errors;

  const ApiErrorResponse({this.errors});

  factory ApiErrorResponse.fromMap(Map<String, dynamic> json) {
    var apiErrors = json["errors"] as List;

    List<ApiError> errors = apiErrors.map((e) => ApiError.fromMap(e)).toList();
    return ApiErrorResponse(errors: errors);
  }

  @override
  List<Object?> get props => [errors];
}

class ApiError extends Equatable {
  final String? rule;
  final String? field;
  final String? message;

  const ApiError({this.rule, this.field, this.message});

  factory ApiError.fromMap(Map<String, dynamic> json) {
    return ApiError(
        rule: json["rule"], field: json["field"], message: json["message"]);
  }

  @override
  List<Object?> get props => [rule, field, message];
}
