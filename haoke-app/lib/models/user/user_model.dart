// lib/models/user/user_model.dart
import 'package:haoke_app/config/env.dart';

class UserModel {
  final String id;
  final String username;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? nickname;
  final String gender;
  final String status;
  final String type;
  final DateTime createTime;
  final DateTime updateTime;
  final DateTime? lastLoginTime;
  final List<UserRole> roles;

  UserModel({
    required this.id,
    required this.username,
    this.email,
    this.phone,
    this.avatar,
    this.nickname,
    this.gender = 'UNKNOWN',
    this.status = 'ACTIVE',
    this.type = 'NORMAL',
    required this.createTime,
    required this.updateTime,
    this.lastLoginTime,
    this.roles = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      username: json['username'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      nickname: json['nickname'] as String?,
      gender: json['gender'] as String? ?? 'UNKNOWN',
      status: json['status'] as String? ?? 'ACTIVE',
      type: json['type'] as String? ?? 'NORMAL',
      createTime: DateTime.parse(json['createTime'] as String),
      updateTime: DateTime.parse(json['updateTime'] as String),
      lastLoginTime: json['lastLoginTime'] != null
          ? DateTime.parse(json['lastLoginTime'] as String)
          : null,
      roles: json['roles'] != null
          ? List<UserRole>.from(
              (json['roles'] as List).map((x) => UserRole.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'nickname': nickname,
      'gender': gender,
      'status': status,
      'type': type,
      'createTime': createTime.toIso8601String(),
      'updateTime': updateTime.toIso8601String(),
      'lastLoginTime': lastLoginTime?.toIso8601String(),
      'roles': roles.map((x) => x.toJson()).toList(),
    };
  }

  // 获取显示名称
  String get displayName => nickname ?? username;

  // 获取头像URL
  String? get avatarUrl {
    if (avatar == null) return null;
    if (avatar!.startsWith('http')) return avatar;
    return '${Env.baseUrl}/files/$avatar';
  }

  // 判断是否为管理员
  bool get isAdmin => type == 'ADMIN' || type == 'SUPER_ADMIN';

  // 判断用户是否激活
  bool get isActive => status == 'ACTIVE';
}

// 用户角色模型
class UserRole {
  final int id;
  final String name;
  final String? description;

  UserRole({required this.id, required this.name, this.description});

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }
}

// 创建用户请求
class CreateUserRequest {
  final String username;
  final String password;
  final String? email;
  final String? phone;
  final String? nickname;
  final String gender;
  final String type;

  CreateUserRequest({
    required this.username,
    required this.password,
    this.email,
    this.phone,
    this.nickname,
    this.gender = 'UNKNOWN',
    this.type = 'NORMAL',
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'phone': phone,
      'nickname': nickname,
      'gender': gender,
      'type': type,
    };
  }
}
