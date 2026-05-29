import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ImagePickerUtil {
  static const MethodChannel _channel =
      MethodChannel('com.example.haoke_rent/image_picker');

  @visibleForTesting
  static bool? debugIsAndroidOverride;

  static bool get _isAndroid => debugIsAndroidOverride ?? Platform.isAndroid;

  /// 选择单张图片
  static Future<File?> pickImage() async {
    if (!_isAndroid) {
      return null;
    }

    try {
      final String? path = await _channel.invokeMethod<String>('pickImage');
      if (path == null || path.isEmpty) return null;
      return File(path);
    } catch (_) {
      return null;
    }
  }

  /// 选择多张图片
  static Future<List<File>> pickMultiImage() async {
    if (!_isAndroid) {
      return [];
    }

    try {
      final List<dynamic>? paths =
          await _channel.invokeMethod<List<dynamic>>('pickMultiImage');
      if (paths == null || paths.isEmpty) return [];

      return paths
          .whereType<String>()
          .where((path) => path.isNotEmpty)
          .map(File.new)
          .toList();
    } catch (_) {
      return [];
    }
  }
}
