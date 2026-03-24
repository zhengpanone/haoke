class LoginRequest {
  final String username;
  final String password;
  final String loginType;
  final String? code;

  LoginRequest({
    required this.username,
    required this.password,
    this.loginType = 'password',
    this.code,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'loginType': loginType,
      'code': code,
    };
  }
}

class RegisterRequest {
  final String username;
  final String password;
  final String confirmPassword;
  final String? email;
  final String? phone;
  final String? nickname;
  final String? gender;
  final String? captcha;

  RegisterRequest({
    required this.username,
    required this.password,
    required this.confirmPassword,
    this.email,
    this.phone,
    this.nickname,
    this.gender = 'UNKNOWN',
    this.captcha,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'confirmPassword': confirmPassword,
      'email': email,
      'phone': phone,
      'nickname': nickname ?? username,
      'gender': gender,
      'captcha': captcha,
    };
  }
}
