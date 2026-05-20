abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = 'Server error']);
}

class CacheFailure extends Failure {
  CacheFailure([super.message = 'Cache error']);
}