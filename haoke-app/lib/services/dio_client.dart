import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/env.dart';
import '../config/app_config.dart';
import '../services/storage_service.dart';
import '../utils/logger.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  late final Dio _client;

  String? _accessToken;
  String? _refreshToken;
  Future<void>? _initializingTokens;

  /// 防止并发刷新 token
  Future<String?>? _refreshing;

  DioClient._internal() {
    final options = BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(milliseconds: AppConfig.connectTimeout),
      receiveTimeout: const Duration(milliseconds: AppConfig.connectTimeout),
      sendTimeout: const Duration(milliseconds: AppConfig.connectTimeout),
      headers: {
        'Accept': 'application/json',
        'Accept-Language': 'zh-CN',
        'User-Agent': 'FlutterApp/${AppConfig.appVersion}',
      },
      responseType: ResponseType.json,
      validateStatus: (status) =>
          status != null && status >= 200 && status < 300,
    );

    _client = Dio(options);

    _client.interceptors.addAll([
      _authInterceptor(),
      _errorInterceptor(),
      if (!kReleaseMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
        ),
    ]);

    _initializingTokens = _initToken();
  }

  /// 初始化 token（从本地加载）
  Future<void> _initToken() async {
    final storage = StorageService.instance;
    _accessToken = await storage.getToken();
    _refreshToken = await storage.getRefreshToken();
  }

  Future<void> _ensureTokenLoaded() async {
    await _initializingTokens;

    if (_accessToken != null && _refreshToken != null) {
      return;
    }

    final storage = StorageService.instance;
    _accessToken ??= await storage.getToken();
    _refreshToken ??= await storage.getRefreshToken();
  }

  /// =========================
  /// Auth 拦截器（核心）
  /// =========================
  Interceptor _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        await _ensureTokenLoaded();

        if (_accessToken != null) {
          options.headers['Authorization'] = 'Bearer $_accessToken';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode != 401) {
          return handler.next(error);
        }

        // 防止死循环
        if (error.requestOptions.extra['retry'] == true) {
          return handler.next(error);
        }

        try {
          final token = await _refreshTokenSafe();

          if (token == null) {
            return handler.next(error);
          }

          final request = error.requestOptions;
          request.headers['Authorization'] = 'Bearer $token';
          request.extra['retry'] = true;

          final response = await _client.fetch(request);
          return handler.resolve(response);
        } catch (e) {
          await _logout();
          return handler.next(error);
        }
      },
    );
  }

  /// =========================
  /// 统一错误处理
  /// =========================
  Interceptor _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        String msg = '网络异常';

        switch (error.type) {
          case DioExceptionType.connectionTimeout:
            msg = '连接超时';
            break;
          case DioExceptionType.receiveTimeout:
            msg = '响应超时';
            break;
          case DioExceptionType.badResponse:
            msg = '服务器错误(${error.response?.statusCode})';
            break;
          case DioExceptionType.unknown:
            msg = '网络错误';
            break;
          default:
        }

        AppLogger.e(msg, error);

        return handler.next(
          DioException(
            requestOptions: error.requestOptions,
            error: msg,
            response: error.response,
            type: error.type,
          ),
        );
      },
    );
  }

  /// =========================
  /// 安全刷新 token（关键）
  /// =========================
  Future<String?> _refreshTokenSafe() async {
    if (_refreshToken == null) return null;

    // 已有刷新任务，直接复用
    if (_refreshing != null) {
      return _refreshing;
    }

    final completer = Completer<String?>();
    _refreshing = completer.future;

    try {
      final resp = await _client.post(
        '/api/auth/refresh-token',
        options: Options(headers: {'Authorization': 'Bearer $_refreshToken'}),
      );

      final token = resp.data['data']['token'];

      _accessToken = token;

      final storage = StorageService.instance;
      await storage.saveToken(token);

      completer.complete(token);
    } catch (e) {
      completer.complete(null);
    } finally {
      _refreshing = null;
    }

    return completer.future;
  }

  /// =========================
  /// 登出
  /// =========================
  Future<void> _logout() async {
    final storage = StorageService.instance;
    await storage.deleteToken();
    await storage.deleteRefreshToken();

    _accessToken = null;
    _refreshToken = null;

    AppLogger.w('用户已登出（token失效）');
  }

  /// =========================
  /// 对外 API
  /// =========================
  Dio get client => _client;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? params,
    Options? options,
  }) {
    return _client.get(path, queryParameters: params, options: options);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
  }) {
    return _client.post(
      path,
      data: data,
      queryParameters: params,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
  }) {
    return _client.put(
      path,
      data: data,
      queryParameters: params,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
  }) {
    return _client.delete(
      path,
      data: data,
      queryParameters: params,
      options: options,
    );
  }
}
