class AppConstants {
  // 存储键名
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserInfo = 'user_info';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';

  // 正则表达式
  static const String emailRegex = r'^[^\s@]+@[^\s@]+\.[^\s@]+$';
  static const String phoneRegex = r'^1[3-9]\d{9}$';
  static const String passwordRegex =
      r'^(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{6,}$';

  // 订单状态
  static const String orderPending = 'pending';
  static const String orderConfirmed = 'confirmed';
  static const String orderCompleted = 'completed';
  static const String orderCancelled = 'cancelled';
}
