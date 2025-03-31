// // api_status_response.dart
// abstract class ApiStatusResponse {}
//
// class Success extends ApiStatusResponse {
//   final int statusCode;
//   final String body;
//
//   Success(this.statusCode, this.body);
// }
//
// class Failure extends ApiStatusResponse {
//   final int statusCode;
//   final String errorResponse;
//
//   Failure(this.statusCode, this.errorResponse);
// }
//
// class UnexpectedError extends ApiStatusResponse {
//   final String message;
//   final StackTrace? stackTrace;
//
//   UnexpectedError(this.message, [this.stackTrace]);
// }
