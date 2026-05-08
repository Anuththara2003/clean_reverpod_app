abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([String message = "Server error occurred"]) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure([String message = "No internet connection"]) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure([String message = "Cache error occurred"]) : super(message);
}