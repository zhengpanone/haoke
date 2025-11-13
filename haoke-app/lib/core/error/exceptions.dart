abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException(super.message) : super(code: 'NETWORK_ERROR');
}

class ServerException extends AppException {
  ServerException(super.message) : super(code: 'SERVER_ERROR');
}

class AuthException extends AppException {
  AuthException(super.message) : super(code: 'AUTH_ERROR');
}

class ValidationException extends AppException {
  ValidationException(super.message) : super(code: 'VALIDATION_ERROR');
}

class CacheException extends AppException {
  CacheException(super.message) : super(code: 'CACHE_ERROR');
}

class UnknownException extends AppException {
  UnknownException(super.message) : super(code: 'UNKNOWN_ERROR');
}
