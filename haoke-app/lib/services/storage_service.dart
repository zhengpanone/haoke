import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:haoke_rent/models/user/user_model.dart';
import 'package:haoke_rent/utils/logger.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();

  static StorageService get instance => _instance;

  StorageService._internal();

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> init() async {
    // flutter_secure_storage is ready to use without explicit initialization.
  }

  Future<String?> getString(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      AppLogger.i('获取字符串失败, key: $key, error: $e');
      return null;
    }
  }

  Future<bool> setString(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
      return true;
    } catch (e) {
      AppLogger.i('设置字符串失败, key: $key, value: $value, error: $e');
      return false;
    }
  }

  Future<bool> deleteString(String key) async {
    try {
      await _secureStorage.delete(key: key);
      return true;
    } catch (e) {
      AppLogger.i('删除字符串失败, key: $key, error: $e');
      return false;
    }
  }

  Future<int?> getInt(String key) async {
    final value = await getString(key);
    return value == null ? null : int.tryParse(value);
  }

  Future<bool> setInt(String key, int value) async {
    return setString(key, value.toString());
  }

  Future<bool?> getBool(String key) async {
    final value = await getString(key);
    if (value == null) return null;
    return value.toLowerCase() == 'true';
  }

  Future<bool> setBool(String key, bool value) async {
    return setString(key, value.toString());
  }

  Future<double?> getDouble(String key) async {
    final value = await getString(key);
    return value == null ? null : double.tryParse(value);
  }

  Future<bool> setDouble(String key, double value) async {
    return setString(key, value.toString());
  }

  Future<List<String>> getStringList(String key) async {
    try {
      final jsonValue = await getString(key);
      if (jsonValue == null || jsonValue.isEmpty) return [];
      final list = json.decode(jsonValue) as List<dynamic>;
      return list.cast<String>();
    } catch (e) {
      AppLogger.i('获取字符串列表失败, key: $key, error: $e');
      return [];
    }
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return setString(key, json.encode(value));
  }

  Future<T?> getObject<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final jsonValue = await getString(key);
      if (jsonValue == null || jsonValue.isEmpty) return null;
      final map = json.decode(jsonValue) as Map<String, dynamic>;
      return fromJson(map);
    } catch (e) {
      AppLogger.i('获取对象失败, key: $key, error: $e');
      return null;
    }
  }

  Future<bool> setObject(String key, dynamic object) async {
    try {
      if (object == null) {
        return deleteString(key);
      }
      final jsonValue = json.encode(object.toJson());
      return setString(key, jsonValue);
    } catch (e) {
      AppLogger.i('设置对象失败, key: $key, error: $e');
      return false;
    }
  }

  Future<bool> containsKey(String key) async {
    final value = await getString(key);
    return value != null;
  }

  Future<List<String>> getKeys() async {
    try {
      final allValues = await _secureStorage.readAll();
      return allValues.keys.toList();
    } catch (e) {
      AppLogger.i('获取所有键失败, error: $e');
      return [];
    }
  }

  Future<bool> deleteMultiple(List<String> keys) async {
    try {
      for (final key in keys) {
        await deleteString(key);
      }
      return true;
    } catch (e) {
      AppLogger.i('批量删除失败, keys: $keys, error: $e');
      return false;
    }
  }

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
          await setObject(key, value);
        }
      }
      return true;
    } catch (e) {
      AppLogger.i('批量设置失败, values: $values, error: $e');
      return false;
    }
  }

  Future<DateTime?> getExpiration(String key) async {
    try {
      final expirationKey = '${key}_expiration';
      final expirationValue = await getString(expirationKey);
      if (expirationValue == null || expirationValue.isEmpty) return null;
      return DateTime.tryParse(expirationValue);
    } catch (e) {
      AppLogger.i('获取过期时间失败, key: $key, error: $e');
      return null;
    }
  }

  Future<bool> setWithExpiration(String key, String value, Duration duration) async {
    try {
      await setString(key, value);
      final expiration = DateTime.now().add(duration);
      final expirationKey = '${key}_expiration';
      await setString(expirationKey, expiration.toIso8601String());
      return true;
    } catch (e) {
      AppLogger.i('设置带过期时间的数据失败, key: $key, error: $e');
      return false;
    }
  }

  Future<bool> isExpired(String key) async {
    final expiration = await getExpiration(key);
    if (expiration == null) return false;
    return DateTime.now().isAfter(expiration);
  }

  Future<void> cleanupExpiredData() async {
    try {
      final keys = await getKeys();
      final keysToDelete = <String>[];

      for (final key in keys) {
        if (key.endsWith('_expiration')) {
          final dataKey = key.replaceFirst('_expiration', '');
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

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  Future<String?> getToken() async {
    return _secureStorage.read(key: 'auth_token');
  }

  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: 'refresh_token', value: token);
  }

  Future<String?> getRefreshToken() async {
    return _secureStorage.read(key: 'refresh_token');
  }

  Future<void> deleteRefreshToken() async {
    await _secureStorage.delete(key: 'refresh_token');
  }

  Future<void> saveUser(UserModel user) async {
    final userJson = json.encode(user.toJson());
    await setString('user_info', userJson);
  }

  Future<UserModel?> getUser() async {
    final userJson = await getString('user_info');
    if (userJson == null || userJson.isEmpty) return null;

    try {
      final userMap = json.decode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteUser() async {
    await deleteString('user_info');
  }

  Future<void> saveLoginState(bool isLoggedIn) async {
    await setBool('is_logged_in', isLoggedIn);
  }

  Future<bool> isLoggedIn() async {
    return (await getBool('is_logged_in')) ?? false;
  }

  Future<void> saveFirstLaunch(bool isFirst) async {
    await setBool('first_launch', isFirst);
  }

  Future<bool> isFirstLaunch() async {
    return (await getBool('first_launch')) ?? true;
  }

  Future<void> saveTheme(String theme) async {
    await setString('app_theme', theme);
  }

  Future<String?> getTheme() async {
    return getString('app_theme');
  }

  Future<void> saveLanguage(String language) async {
    await setString('app_language', language);
  }

  Future<String?> getLanguage() async {
    return getString('app_language');
  }

  Future<void> clearAll() async {
    await _secureStorage.deleteAll();
  }
}
