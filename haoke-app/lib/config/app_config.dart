// 应用配置
class AppConfig {
  static const String appName = '好客租房';
  static const String appVersion = '1.0.0';

  static const int connectTimeout = 30000; // 30秒
  static const int receiveTimeout = 30000; // 30秒

  // icon配置
  static const commonIcon = 'CommonIcon';

  // 分页配置
  static const int pageSize = 20;
  static const int maxPageSize = 100;

  static Future<void> loadAppInfo() async {
    // 这里可以添加从其他来源加载应用信息的逻辑
    // 例如从服务器获取版本信息
    await Future.delayed(Duration.zero);
  }
}
