import 'package:dio/dio.dart';
import 'package:haoke_rent/models/common/api_response.dart';
import 'package:haoke_rent/models/auth/login_request.dart';
import 'package:haoke_rent/models/auth/login_response.dart';
import 'package:haoke_rent/models/user/user_model.dart';
import 'package:haoke_rent/services/dio_client.dart';
import 'package:haoke_rent/services/storage_service.dart';
import 'package:haoke_rent/utils/logger.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  ApiService._internal();

  final Dio _dio = DioClient().client;

  final StorageService _storage = StorageService.instance;

  // 用户注册
  Future<ApiResponse<LoginResponse>> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: request.toJson(),
      );
      final apiResponse = ApiResponse<LoginResponse>.fromJson(
        response.data,
        (data) => LoginResponse.fromJson(data as Map<String, dynamic>),
      );
      if (apiResponse.isSuccess && apiResponse.data != null) {
        // 保存Token
        await _storage.saveToken(apiResponse.data!.token);

        // 保存用户信息
        final user = UserModel(
          id: apiResponse.data!.userId,
          username: apiResponse.data!.username,
          email: apiResponse.data!.email,
          phone: apiResponse.data!.phone,
          avatar: apiResponse.data!.avatar,
          nickname: apiResponse.data!.nickname,
          gender: apiResponse.data!.gender ?? 'UNKNOWN',
          type: apiResponse.data!.type ?? 'NORMAL',
          createTime: DateTime.now(),
          updateTime: DateTime.now(),
        );
        await _storage.saveUser(user);
        await _storage.saveLoginState(true);
      }
      return apiResponse;
    } catch (e) {
      AppLogger.e('用户注册失败： $e');
      rethrow;
    }
  }

  // 用户登录
  Future<ApiResponse<LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: request.toJson(),
      );
      final apiResponse = ApiResponse<LoginResponse>.fromJson(
        response.data,
        (data) => LoginResponse.fromJson(data as Map<String, dynamic>),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        // 保存 Token
        await _storage.saveToken(apiResponse.data!.token);
        // 保存用户信息
        // 保存用户信息
        final user = UserModel(
          id: apiResponse.data!.userId,
          username: apiResponse.data!.username,
          email: apiResponse.data!.email,
          phone: apiResponse.data!.phone,
          avatar: apiResponse.data!.avatar,
          nickname: apiResponse.data!.nickname,
          gender: apiResponse.data!.gender ?? 'UNKNOWN',
          type: apiResponse.data!.type ?? 'NORMAL',
          createTime: DateTime.now(),
          updateTime: DateTime.now(),
        );
        await _storage.saveUser(user);
        await _storage.saveLoginState(true);
      }
      return apiResponse;
    } catch (e) {
      AppLogger.e('用户登录失败: $e');
      rethrow;
    }
  }
}
