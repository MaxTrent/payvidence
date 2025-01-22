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

class NetworkFailure {
  int code = 500;
  String message = "Network Failure";
}



class ForbiddenAccess {
  int code = 403;
  String message = "Forbidden Access";
}

class UnexpectedError {
  int code = 0;
  String message = "An unexpected error occurred";
}