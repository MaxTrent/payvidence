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
          (failure) => ApiResult(error: failure.error),
          (success) => ApiResult(success: true, data: success.data),
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
      ApiErrorResponseV2.fromMap(
        json["message"]?.toString() ?? "Unknown error",
        json["errors"] ?? json,
      ),
    );
  }

  @override
  List<Object?> get props => [error];
}

class ApiErrorResponseV2 extends Equatable {
  final String? message;
  final List<ApiError>? errors;

  const ApiErrorResponseV2({this.message, this.errors});

  factory ApiErrorResponseV2.fromMap(String message, dynamic errorData) {
    try {
      List<ApiError>? errors;

      if (errorData is List) {
        errors = errorData.map((e) => ApiError.fromMap(e)).toList();
      }
      else if (errorData is String) {
        errors = [ApiError(message: errorData)];
      }
      else if (errorData is Map<String, dynamic>) {
        errors = [];
        errorData.forEach((key, value) {
          if (value is List) {
            errors!.addAll(value.map((e) => ApiError(field: key, message: e.toString())));
          } else {
            errors!.add(ApiError(field: key, message: value.toString()));
          }
        });
      }

      return ApiErrorResponseV2(
        message: message,
        errors: errors,
      );
    } catch (e) {
      return ApiErrorResponseV2(
        message: "Error parsing response: $message",
        errors: const [ApiError(message: "Failed to parse error details")],
      );
    }
  }

  @override
  List<Object?> get props => [message, errors];
}

class ApiError extends Equatable {
  final String? rule;
  final String? field;
  final String? message;

  const ApiError({this.rule, this.field, this.message});

  factory ApiError.fromMap(dynamic json) {
    try {
      if (json is Map<String, dynamic>) {
        return ApiError(
          rule: json["rule"]?.toString(),
          field: json["field"]?.toString(),
          message: json["message"]?.toString(),
        );
      }
      return ApiError(message: json.toString());
    } catch (e) {
      return const ApiError(message: "Invalid error format");
    }
  }

  @override
  List<Object?> get props => [rule, field, message];
}