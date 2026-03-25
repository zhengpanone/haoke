// lib/services/storage_service.dart
import 'dart:convert';
import 'package:haoke_rent/models/user/user_model.dart';
import 'package:haoke_rent/utils/logger.dart';
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

  // ==================== 通用存储方法 ====================
  // 获取字符串
  Future<String?> getString(String key) async {
    try {
      // 先尝试从安全存储获取
      String? value = await _secureStorage.read(key: key);
      if (value != null) return value;

      // 如果安全存储没有，从 SharedPreferences 获取
      return _prefs?.getString(key);
    } catch (e) {
      AppLogger.i('获取字符串失败, key: $key, error: $e');
      return null;
    }
  }

  // 设置字符串
  Future<bool> setString(String key, String value) async {
    try {
      // 存储到安全存储
      await _secureStorage.write(key: key, value: value);

      // 同时存储到 SharedPreferences
      await _prefs?.setString(key, value);

      return true;
    } catch (e) {
      AppLogger.i('设置字符串失败, key: $key, value: $value, error: $e');
      return false;
    }
  }

  // 删除字符串
  Future<bool> deleteString(String key) async {
    try {
      // 从安全存储删除
      await _secureStorage.delete(key: key);

      // 从 SharedPreferences 删除
      await _prefs?.remove(key);

      return true;
    } catch (e) {
      AppLogger.i('删除字符串失败, key: $key, error: $e');
      return false;
    }
  }

  // 获取整数
  Future<int?> getInt(String key) async {
    try {
      // 先尝试从字符串中解析
      String? stringValue = await getString(key);
      if (stringValue != null) {
        return int.tryParse(stringValue);
      }

      // 从 SharedPreferences 直接获取
      return _prefs?.getInt(key);
    } catch (e) {
      AppLogger.i('获取整数失败, key: $key, error: $e');
      return null;
    }
  }

  // 设置整数
  Future<bool> setInt(String key, int value) async {
    try {
      // 转换为字符串存储
      await setString(key, value.toString());

      // 同时存储到 SharedPreferences
      await _prefs?.setInt(key, value);

      return true;
    } catch (e) {
      AppLogger.i('设置整数失败, key: $key, value: $value, error: $e');
      return false;
    }
  }

  // 获取布尔值
  Future<bool?> getBool(String key) async {
    try {
      String? stringValue = await getString(key);
      if (stringValue != null) {
        return stringValue.toLowerCase() == 'true';
      }

      return _prefs?.getBool(key);
    } catch (e) {
      AppLogger.i('获取布尔值失败, key: $key, error: $e');
      return null;
    }
  }

  // 设置布尔值
  Future<bool> setBool(String key, bool value) async {
    try {
      await setString(key, value.toString());
      await _prefs?.setBool(key, value);
      return true;
    } catch (e) {
      AppLogger.i('设置布尔值失败, key: $key, value: $value, error: $e');
      return false;
    }
  }

  // 获取双精度浮点数
  Future<double?> getDouble(String key) async {
    try {
      String? stringValue = await getString(key);
      if (stringValue != null) {
        return double.tryParse(stringValue);
      }

      return _prefs?.getDouble(key);
    } catch (e) {
      AppLogger.i('获取双精度浮点数失败, key: $key, error: $e');
      return null;
    }
  }

  // 设置双精度浮点数
  Future<bool> setDouble(String key, double value) async {
    try {
      await setString(key, value.toString());
      await _prefs?.setDouble(key, value);
      return true;
    } catch (e) {
      AppLogger.i('设置双精度浮点数失败, key: $key, value: $value, error: $e');
      return false;
    }
  }

  // 获取字符串列表
  Future<List<String>> getStringList(String key) async {
    try {
      String? jsonValue = await getString(key);
      if (jsonValue != null && jsonValue.isNotEmpty) {
        try {
          final List<dynamic> list = json.decode(jsonValue);
          return list.cast<String>();
        } catch (e) {
          AppLogger.i('解析字符串列表失败, key: $key, value: $jsonValue');
        }
      }

      return _prefs?.getStringList(key) ?? [];
    } catch (e) {
      AppLogger.i('获取字符串列表失败, key: $key, error: $e');
      return [];
    }
  }

  // 设置字符串列表
  Future<bool> setStringList(String key, List<String> value) async {
    try {
      await setString(key, json.encode(value));
      await _prefs?.setStringList(key, value);
      return true;
    } catch (e) {
      AppLogger.i('设置字符串列表失败, key: $key, value: $value, error: $e');
      return false;
    }
  }

  // 获取对象
  Future<T?> getObject<T>(
      String key, T Function(Map<String, dynamic>) fromJson) async {
    try {
      String? jsonValue = await getString(key);
      if (jsonValue != null && jsonValue.isNotEmpty) {
        try {
          final Map<String, dynamic> map = json.decode(jsonValue);
          return fromJson(map);
        } catch (e) {
          AppLogger.i('解析对象失败, key: $key, error: $e');
        }
      }
      return null;
    } catch (e) {
      AppLogger.i('获取对象失败, key: $key, error: $e');
      return null;
    }
  }

  // 设置对象
  Future<bool> setObject(String key, dynamic object) async {
    try {
      if (object == null) {
        return await deleteString(key);
      }

      final String jsonValue = json.encode(object.toJson());
      return await setString(key, jsonValue);
    } catch (e) {
      AppLogger.i('设置对象失败, key: $key, error: $e');
      return false;
    }
  }

  // 检查键是否存在
  Future<bool> containsKey(String key) async {
    try {
      // 检查安全存储
      final allValues = await _secureStorage.readAll();
      if (allValues.containsKey(key)) {
        return true;
      }

      // 检查 SharedPreferences
      return _prefs?.containsKey(key) ?? false;
    } catch (e) {
      AppLogger.i('检查键失败, key: $key, error: $e');
      return false;
    }
  }

  // 获取所有键
  Future<List<String>> getKeys() async {
    try {
      final List<String> keys = [];

      // 获取安全存储的键
      final allValues = await _secureStorage.readAll();
      keys.addAll(allValues.keys);

      // 获取 SharedPreferences 的键
      if (_prefs != null) {
        keys.addAll(_prefs!.getKeys());
      }

      // 去重
      return keys.toSet().toList();
    } catch (e) {
      AppLogger.i('获取所有键失败, error: $e');
      return [];
    }
  }

  // 批量删除
  Future<bool> deleteMultiple(List<String> keys) async {
    try {
      for (String key in keys) {
        await deleteString(key);
      }
      return true;
    } catch (e) {
      AppLogger.i('批量删除失败, keys: $keys, error: $e');
      return false;
    }
  }

  // 批量设置
  Future<bool> setMultiple(Map<String, dynamic> values) async {
    try {
      for (final entry in values.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is String) {
          await setString(key, value);
        } else if (value is int) {
          await setInt(key, value);
        } else if (value is bool) {
          await setBool(key, value);
        } else if (value is double) {
          await setDouble(key, value);
        } else if (value is List<String>) {
          await setStringList(key, value);
        } else {
          // 尝试作为对象处理
          await setObject(key, value);
        }
      }
      return true;
    } catch (e) {
      AppLogger.i('批量设置失败, values: $values, error: $e');
      return false;
    }
  }

  // 获取过期时间
  Future<DateTime?> getExpiration(String key) async {
    try {
      final String? expirationKey = '${key}_expiration';
      final String? expirationValue = await getString(expirationKey!);

      if (expirationValue != null && expirationValue.isNotEmpty) {
        return DateTime.tryParse(expirationValue);
      }
      return null;
    } catch (e) {
      AppLogger.i('获取过期时间失败, key: $key, error: $e');
      return null;
    }
  }

  // 设置带过期时间的数据
  Future<bool> setWithExpiration(
      String key, String value, Duration duration) async {
    try {
      await setString(key, value);

      final DateTime expiration = DateTime.now().add(duration);
      final String expirationKey = '${key}_expiration';
      await setString(expirationKey, expiration.toIso8601String());

      return true;
    } catch (e) {
      AppLogger.i('设置带过期时间的数据失败, key: $key, error: $e');
      return false;
    }
  }

  // 检查数据是否过期
  Future<bool> isExpired(String key) async {
    try {
      final DateTime? expiration = await getExpiration(key);
      if (expiration == null) {
        return false; // 没有设置过期时间，永不过期
      }
      return DateTime.now().isAfter(expiration);
    } catch (e) {
      AppLogger.i('检查过期状态失败, key: $key, error: $e');
      return false;
    }
  }

  // 清理过期数据
  Future<void> cleanupExpiredData() async {
    try {
      final List<String> keys = await getKeys();
      final List<String> keysToDelete = [];

      for (final key in keys) {
        if (key.endsWith('_expiration')) {
          final String dataKey = key.replaceFirst('_expiration', '');
          if (await isExpired(dataKey)) {
            keysToDelete.addAll([dataKey, key]);
          }
        }
      }

      if (keysToDelete.isNotEmpty) {
        await deleteMultiple(keysToDelete);
        AppLogger.i('已清理过期数据 ${keysToDelete.length ~/ 2} 条');
      }
    } catch (e) {
      AppLogger.i('清理过期数据失败, error: $e');
    }
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
