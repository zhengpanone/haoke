class Validators {
  // 用户名验证
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入用户名';
    }
    if (value.length < 3 || value.length > 20) {
      return '用户名长度必须在3-20个字符之间';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return '用户名只能包含字母、数字和下划线';
    }
    return null;
  }

  // 密码验证
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    if (value.length < 6) {
      return '密码长度不能少于6位';
    }
    if (value.length > 20) {
      return '密码长度不能超过20位';
    }
    return null;
  }

  // 确认密码验证
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return '请确认密码';
    }
    if (value != password) {
      return '两次输入的密码不一致';
    }
    return null;
  }

  // 邮箱验证
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // 邮箱可选
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return '请输入有效的邮箱地址';
    }
    return null;
  }

  // 手机号验证
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // 手机号可选
    }
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(value)) {
      return '请输入有效的手机号码';
    }
    return null;
  }

  // 昵称验证
  static String? validateNickname(String? value) {
    if (value == null || value.isEmpty) {
      return null; // 昵称可选
    }
    if (value.length < 2 || value.length > 20) {
      return '昵称长度必须在2-20个字符之间';
    }
    return null;
  }

  // 验证码验证
  static String? validateCaptcha(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入验证码';
    }
    if (value.length != 6) {
      return '验证码为6位数字';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return '验证码必须为数字';
    }
    return null;
  }
}
