sealed class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Check your internet connection',
  ]);
}

class ServerException extends AppException {
  const ServerException([
    super.message = 'Server error. Please try again later',
  ]);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([
    super.message = 'You are not authorized',
  ]);
}

class NotFoundException extends AppException {
  const NotFoundException([
    super.message = 'Resource not found',
  ]);
}

class UnknownException extends AppException {
  const UnknownException([
    super.message = 'Something went wrong',
  ]);
}