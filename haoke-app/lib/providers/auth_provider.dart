// 状态管理
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:haoke_app/models/auth/login_request.dart';
import 'package:haoke_app/models/user/update_user_profile_request.dart';
import 'package:haoke_app/models/user/user_model.dart';
import 'package:haoke_app/services/api_service.dart';
import 'package:haoke_app/services/storage_service.dart';
import 'package:haoke_app/utils/logger.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;

  bool get isLoading => _isLoading;

  bool get isLoggedIn => _isLoggedIn;

  String? get errorMessage => _errorMessage;

  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService.instance;

  AuthProvider() {
    _init();
  }

  // 初始化
  Future<void> _init() async {
    await _checkLoginStatus();
  }

  // 检查登录状态
  Future<void> _checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();
    try {
      final isLoggedIn = await _storageService.isLoggedIn();
      if (isLoggedIn) {
        final user = await _storageService.getUser();
        if (user != null) {
          _currentUser = user;
          _isLoggedIn = true;
        }
      }
    } catch (e) {
      AppLogger.e("检查登录状态失败:$e");
    } finally {
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    }
  }

  // 登录
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await _apiService.login(
        LoginRequest(username: username, password: password),
      );
      if (response.isSuccess) {
        _isLoggedIn = true;
        await _syncUserInfo();
        return true;
      } else {
        _errorMessage = response.message;
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.logout();
      await _clearUserData();
    } catch (e) {
      AppLogger.e('退出登录失败： $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> unbindPhone() async {
    _isLoading = true;
    _errorMessage = null;
    try {
      final response = await _apiService.unbindPhone();
      if (response.isSuccess) {
        _isLoggedIn = true;
        await _syncUserInfo();
        return true;
      } else {
        _errorMessage = response.message;
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> sendPhoneCode(String phone) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await _apiService.sendPhoneCode(phone);
      if (response.isSuccess) {
        return response.data;
      }
      _errorMessage = response.message;
      return null;
    } catch (e) {
      _errorMessage = e.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> bindPhone(String phone, String code) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await _apiService.bindPhone(phone: phone, code: code);
      if (response.isSuccess && response.data != null) {
        _currentUser = response.data;
        await _storageService.saveUser(_currentUser!);
        _isLoggedIn = true;
        return true;
      }
      _errorMessage = response.message;
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 同步用户信息
  Future<void> _syncUserInfo() async {
    try {
      final response = await _apiService.getCurrentUser();
      if (response.isSuccess && response.data != null) {
        _currentUser = response.data;
        await _storageService.saveUser(_currentUser!);
      }
    } catch (e) {
      AppLogger.e('同步用户信息失败： $e');
    }
  }

  /// 清除用户数据
  Future<void> _clearUserData() async {
    _currentUser = null;
    _isLoggedIn = false;
    await _storageService.clearAll();
  }

  /// 同步用户信息（增强版）
  /// 支持强制刷新和缓存策略
  Future<bool> syncUserInfo({bool forceRefresh = false}) async {
    // 检查是否需要同步
    if (!forceRefresh && _shouldUseCache()) {
      _currentUser = await _storageService.getUser();
      if (_currentUser != null) {
        AppLogger.i('使用缓存的用户信息');
        return true;
      }
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.getCurrentUser();

      if (response.isSuccess && response.data != null) {
        _currentUser = response.data;
        await _storageService.saveUser(_currentUser!);

        // 记录同步时间
        final now = DateTime.now();
        await _storageService.setString(
          'last_sync_time',
          now.toIso8601String(),
        );

        _isLoading = false;
        _errorMessage = null;
        notifyListeners();

        AppLogger.i('用户信息同步成功: ${_currentUser!.username}');
        return true;
      } else {
        _errorMessage = response.message;
        _currentUser = await _storageService.getUser();

        _isLoading = false;
        notifyListeners();

        AppLogger.w('用户信息同步失败: ${response.message}');
        return false;
      }
    } catch (e, stackTrace) {
      _errorMessage = '网络异常: $e';
      _currentUser = await _storageService.getUser();

      _isLoading = false;
      notifyListeners();

      AppLogger.e('用户信息同步异常', e, stackTrace);
      return false;
    }
  }

  /// 检查是否应该使用缓存
  bool _shouldUseCache() {
    final lastSyncTime = _storageService.getString('last_sync_time');

    try {
      final lastSync = DateTime.parse(lastSyncTime as String);
      final now = DateTime.now();
      final diff = now.difference(lastSync);

      // 如果缓存时间在5分钟内，使用缓存
      return diff.inMinutes < 5;
    } catch (e) {
      return false;
    }
  }

  /// 获取用户信息（智能获取）
  Future<UserModel?> getUserInfo({bool forceRefresh = false}) async {
    if (_currentUser != null && !forceRefresh) {
      return _currentUser;
    }

    await syncUserInfo(forceRefresh: forceRefresh);
    return _currentUser;
  }

  Future<bool> updateUserInfo(
    UpdateUserProfileRequest request, {
    File? avatarFile,
  }) async {
    if (_currentUser == null) {
      _errorMessage = 'User is not logged in';
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var profileRequest = request;
      if (avatarFile != null) {
        final uploadResponse = await _apiService.uploadAvatar(avatarFile);
        if (!uploadResponse.isSuccess || uploadResponse.data == null) {
          _errorMessage = uploadResponse.message.isNotEmpty
              ? uploadResponse.message
              : 'Avatar upload failed';
          _isLoading = false;
          notifyListeners();
          return false;
        }
        profileRequest = request.copyWith(avatar: uploadResponse.data);
      }

      final response = await _apiService.updateCurrentUser(profileRequest);
      if (response.isSuccess && response.data != null) {
        _currentUser = response.data;
        await _storageService.saveUser(_currentUser!);
        _isLoggedIn = true;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = response.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();
      AppLogger.e('Update user info failed', e, stackTrace);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 更新用户信息
  // Future<bool> updateUserInfo(Map<String, dynamic> data) async {
  //   if (_currentUser == null) {
  //     return false;
  //   }
  //
  //   _isLoading = true;
  //   _errorMessage = null;
  //   notifyListeners();
  //
  //   try {
  //     final response = await _apiService.updateCurrentUser(data);
  //
  //     if (response.isSuccess && response.data != null) {
  //       _currentUser = response.data;
  //       await _storageService.saveUser(_currentUser!);
  //
  //       _isLoading = false;
  //       notifyListeners();
  //
  //       // 显示成功提示
  //       _showSuccessMessage('用户信息更新成功');
  //       return true;
  //     } else {
  //       _errorMessage = response.message;
  //
  //       _isLoading = false;
  //       notifyListeners();
  //
  //       _showErrorMessage(_errorMessage ?? '更新失败');
  //       return false;
  //     }
  //   } catch (e, stackTrace) {
  //     _errorMessage = '更新失败: $e';
  //
  //     _isLoading = false;
  //     notifyListeners();
  //
  //     _showErrorMessage(_errorMessage!);
  //     AppLogger.e('更新用户信息异常', e, stackTrace);
  //     return false;
  //   }
  // }

  // 更新头像
  // Future<bool> updateAvatar(String avatarUrl) async {
  //   if (_currentUser == null) {
  //     return false;
  //   }
  //
  //   _isLoading = true;
  //   _errorMessage = null;
  //   notifyListeners();
  //
  //   try {
  //     final response = await _apiService.updateAvatar(avatarUrl);
  //
  //     if (response.isSuccess && response.data != null) {
  //       _currentUser = response.data;
  //       await _storageService.saveUser(_currentUser!);
  //
  //       _isLoading = false;
  //       notifyListeners();
  //
  //       _showSuccessMessage('头像更新成功');
  //       return true;
  //     } else {
  //       _errorMessage = response.message;
  //
  //       _isLoading = false;
  //       notifyListeners();
  //
  //       _showErrorMessage(_errorMessage ?? '头像更新失败');
  //       return false;
  //     }
  //   } catch (e, stackTrace) {
  //     _errorMessage = '头像更新失败: $e';
  //
  //     _isLoading = false;
  //     notifyListeners();
  //
  //     _showErrorMessage(_errorMessage!);
  //     AppLogger.e('更新头像异常', e, stackTrace);
  //     return false;
  //   }
  // }

  // 修改密码
  // Future<bool> changePassword(String oldPassword, String newPassword) async {
  //   if (_currentUser == null) {
  //     return false;
  //   }
  //
  //   _isLoading = true;
  //   _errorMessage = null;
  //   notifyListeners();
  //
  //   try {
  //     final response = await _apiService.changePassword(
  //       oldPassword: oldPassword,
  //       newPassword: newPassword,
  //     );
  //
  //     if (response.isSuccess) {
  //       _isLoading = false;
  //       notifyListeners();
  //
  //       _showSuccessMessage('密码修改成功');
  //       return true;
  //     } else {
  //       _errorMessage = response.message;
  //
  //       _isLoading = false;
  //       notifyListeners();
  //
  //       _showErrorMessage(_errorMessage ?? '密码修改失败');
  //       return false;
  //     }
  //   } catch (e, stackTrace) {
  //     _errorMessage = '密码修改失败: $e';
  //
  //     _isLoading = false;
  //     notifyListeners();
  //
  //     _showErrorMessage(_errorMessage!);
  //     AppLogger.e('修改密码异常', e, stackTrace);
  //     return false;
  //   }
  // }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await _apiService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      if (response.isSuccess) {
        return true;
      }
      _errorMessage = response.message;
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
