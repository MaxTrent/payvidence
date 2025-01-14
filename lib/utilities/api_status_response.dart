class Success {
  int code;
  String body;
  Success(this.code, this.body);
}

class Failure {
  int code;
  String errorResponse;
  Failure(this.code, this.errorResponse);
}

class NetWorkFailure {
  int code = 500;
  String message = "Network Failure";
}

class ForbiddenAccess {
  int code = 403;
  String message = "Forbidden Access";
}

class UnExpectedError {
  int code = 0;
  String message = "An unexpected error occurred";
}