import 'package:intl/intl.dart';

extension StringExtension on String {
  // 检查是否为空或空白
  bool get isNullOrEmpty => trim().isEmpty;

  // 检查是否为邮箱
  bool get isEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  // 检查是否为手机号
  bool get isPhone => RegExp(r'^1[3-9]\d{9}$').hasMatch(this);

  // 首字母大写
  String get capitalize =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  // 隐藏部分手机号
  String get maskedPhone {
    if (length != 11) return this;
    return replaceRange(3, 7, '****');
  }

  // 隐藏部分邮箱
  String get maskedEmail {
    if (!contains('@')) return this;
    final parts = split('@');
    if (parts.length != 2) return this;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) {
      return '***@$domain';
    }

    final maskedUsername =
        '${username.substring(0, 1)}***${username.substring(username.length - 1)}';
    return '$maskedUsername@$domain';
  }
}

extension DateTimeExtension on DateTime {
  // 格式化日期
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }

  // 相对时间
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return '刚刚';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}天前';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}个月前';
    } else {
      return '${(difference.inDays / 365).floor()}年前';
    }
  }
}
