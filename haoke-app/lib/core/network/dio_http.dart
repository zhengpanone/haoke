import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:haoke_rent/config/api_config.dart';

class DioHttp {
  // 单例实例
  static DioHttp? _instance;
  late Dio _client;
  BuildContext _context;

  // 便捷方法：通过 context 获取实例
  factory DioHttp.of(BuildContext context) {
    // 如果实例不存在，创建新实例
    if (_instance == null) {
      _instance = DioHttp._internal(context);
    } else {
      // 如果实例存在，更新 context
      _instance!._context = context;
      // 同时更新 Dio 的 extra 中的 context
      _instance!._client.options.extra['context'] = context;
    }
    return _instance!;
  }

  // 私有构造函数
  DioHttp._internal(BuildContext context) : _context = context {
    var options = BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      extra: {'context': context},
      // headers: {
      //   'Content-Type': 'application/json',
      //   'Accept': 'application/json',
      // },
      // responseType: ResponseType.json,
      followRedirects: true,
      validateStatus: (status) {
        return status != null && status < 500;
      },
    );

    var client = Dio(options);
    this._client = client;
  }

  // 获取当前 context
  BuildContext get context => _context;

  // 获取 Dio 客户端
  Dio get client => _client;

  // 更新 context
  void updateContext(BuildContext context) {
    _context = context;
    _client.options.extra['context'] = context;
  }

  // 重置实例（用于测试或特殊场景）
  static void resetInstance() {
    _instance = null;
  }

  // 添加一些常用的请求方法
  Future<Response<Map<String, dynamic>>> get(
    String path, [
    Map<String, dynamic>? params,
    Options? options,
    String? token,
  ]) async {
    return _client.get(path, queryParameters: params, options: options);
  }

  Future<Response<Map<String, dynamic>>> post(
    String path, [
    dynamic data,
    Options? options,
    Map<String, dynamic>? params,
    String? token,
  ]) async {
    return _client.post(
      path,
      data: data,
      queryParameters: params,
      options: options,
    );
  }

  // Future<Response<T>> deleteUri<T>
  // Future<Response<Map<String, dynamic>>>
  Future<Response<T>> deleteUri<T>(
    String path,
    dynamic data, [
    Options? options,
    Map<String, dynamic>? params,
    String? token,
  ]) async {
    return _client.delete(
      path,
      data: data,
      queryParameters: params,
      options: options,
    );
  }

  Future<Response> put(
    String path, {
    dynamic data,

    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _client.put(
      path,
      data: data,
      queryParameters: params,
      options: options,
      cancelToken: cancelToken,
    );
  }
}
