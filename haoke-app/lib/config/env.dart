class Env {
  // 开发环境
  static const String devBaseUrl = 'http://10.0.2.2:8080';
  static const String devWsUrl = 'ws://127.0.0.1:8080/ws';

  // 测试环境
  static const String testBaseUrl = 'http://test.example.com';
  static const String testWsUrl = 'ws://test.example.com/ws';

  // 生产环境
  static const String prodBaseUrl = 'https://api.example.com';
  static const String prodWsUrl = 'wss://api.example.com/ws';

  // 获取当前环境的基础URL
  static String get baseUrl {
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

    switch (flavor) {
      case 'prod':
        return prodBaseUrl;
      case 'test':
        return testBaseUrl;
      default:
        return devBaseUrl;
    }
  }

  static String get wsUrl {
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

    switch (flavor) {
      case 'prod':
        return prodWsUrl;
      case 'test':
        return testWsUrl;
      default:
        return devWsUrl;
    }
  }
}

class ApiConfig {

  // API端点
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';

  // 请求头
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
}
