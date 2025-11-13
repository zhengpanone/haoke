import 'package:dio/dio.dart';
import 'package:haoke_rent/core/error/exceptions.dart';

class ErrorHandler {
  static AppException handleError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is AppException) {
      return error;
    } else {
      return UnknownException('未知错误: ${error.toString()}');
    }
  }

  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('网络连接超时, 请检查网络设置');
      case DioExceptionType.badResponse:
        return _handleResponseError(error);
      case DioExceptionType.cancel:
        return NetworkException('请求已取消');
      default:
        return UnknownException('网络请求失败');
    }
  }

  static AppException _handleResponseError(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    switch (statusCode) {
      case 400:
        return ValidationException(data?['message'] ?? '请求参数错误');
      case 401:
        return AuthException('登录已过期, 请重新登陆');
      case 403:
        return AuthException('权限不足，无法访问');
      case 404:
        return ServerException('请求的资源不存在');
      case 500:
        return ServerException('服务器内部错误');
      case 502:
        return ServerException('网关错误');
      case 503:
        return ServerException('服务不可用');
      default:
        return ServerException(data?['message'] ?? '服务器错误');
    }
  }

  static String getErrorMessage(AppException exception) {
    switch (exception.runtimeType) {
      case const (NetworkException):
        return '网络连接异常，请检查网络设置';
      case const (ServerException):
        return exception.message;
      case const (AuthException):
        return exception.message;
      case const (ValidationException):
        return exception.message;
      case const (CacheException):
        return '缓存异常';
      default:
        return '未知错误，请稍后重试';
    }
  }
}
