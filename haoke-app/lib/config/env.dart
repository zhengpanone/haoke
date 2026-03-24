class Env {
  // 开发环境
  static const String devBaseUrl = 'http://127.0.0.1:8080';
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
