// lib/services/storage_service.dart
import 'dart:convert';
import 'package:haoke_rent/models/user/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();

  static StorageService get instance => _instance;

  StorageService._internal();

  static const _secureStorage = FlutterSecureStorage();
  SharedPreferences? _prefs;

  // 初始化
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token 相关
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  // Refresh Token
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: 'refresh_token', value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  Future<void> deleteRefreshToken() async {
    await _secureStorage.delete(key: 'refresh_token');
  }

  // 用户信息
  Future<void> saveUser(UserModel user) async {
    final userJson = json.encode(user.toJson());
    await _prefs?.setString('user_info', userJson);
  }

  Future<UserModel?> getUser() async {
    final userJson = _prefs?.getString('user_info');
    if (userJson == null) return null;

    try {
      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteUser() async {
    await _prefs?.remove('user_info');
  }

  // 登录状态
  Future<void> saveLoginState(bool isLoggedIn) async {
    await _prefs?.setBool('is_logged_in', isLoggedIn);
  }

  Future<bool> isLoggedIn() async {
    return _prefs?.getBool('is_logged_in') ?? false;
  }

  // 首次启动
  Future<void> saveFirstLaunch(bool isFirst) async {
    await _prefs?.setBool('first_launch', isFirst);
  }

  Future<bool> isFirstLaunch() async {
    return _prefs?.getBool('first_launch') ?? true;
  }

  // 主题设置
  Future<void> saveTheme(String theme) async {
    await _prefs?.setString('app_theme', theme);
  }

  Future<String?> getTheme() async {
    return _prefs?.getString('app_theme');
  }

  // 语言设置
  Future<void> saveLanguage(String language) async {
    await _prefs?.setString('app_language', language);
  }

  Future<String?> getLanguage() async {
    return _prefs?.getString('app_language');
  }

  // 清除所有数据
  Future<void> clearAll() async {
    await deleteToken();
    await deleteRefreshToken();
    await deleteUser();
    await _prefs?.clear();
  }
}
