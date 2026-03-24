class LoginResponse {
  final String token;
  final String tokenType;
  final int userId;
  final String username;
  final String? email;
  final String? phone;
  final String? avatar;
  final String? nickname;
  final String? gender;
  final String? type;
  final DateTime? expiresAt;
  final DateTime? loginTime;

  LoginResponse({
    required this.token,
    this.tokenType = 'Bearer',
    required this.userId,
    required this.username,
    this.email,
    this.phone,
    this.avatar,
    this.nickname,
    this.gender,
    this.type,
    this.expiresAt,
    this.loginTime,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      userId: json['userId'] as int,
      username: json['username'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      nickname: json['nickname'] as String?,
      gender: json['gender'] as String?,
      type: json['type'] as String?,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
      loginTime: json['loginTime'] != null
          ? DateTime.parse(json['loginTime'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'tokenType': tokenType,
      'userId': userId,
      'username': username,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'nickname': nickname,
      'gender': gender,
      'type': type,
      'expiresAt': expiresAt?.toIso8601String(),
      'loginTime': loginTime?.toIso8601String(),
    };
  }
}
