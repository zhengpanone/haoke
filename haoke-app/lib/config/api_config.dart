class ApiConfig {
  static const baseUrl = 'http://127.0.0.1:8080';

  // API端点
  static final String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';

  // 请求头
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
}
