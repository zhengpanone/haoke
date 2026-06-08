import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  static String? lastError;

  @visibleForTesting
  static bool? debugIsAndroidOverride;

  @visibleForTesting
  static Future<File?> Function()? debugPickImageHandler;

  @visibleForTesting
  static Future<List<File>> Function()? debugPickMultiImageHandler;

  static bool get _canPick => !kIsWeb && (debugIsAndroidOverride ?? true);

  static Future<File?> pickImage() async {
    lastError = null;
    if (!_canPick) {
      lastError = 'Unsupported platform';
      return null;
    }
    if (debugPickImageHandler != null) {
      return debugPickImageHandler!();
    }

    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image == null || image.path.isEmpty) return null;
      return File(image.path);
    } catch (e) {
      lastError = e.toString();
      return null;
    }
  }

  static Future<List<File>> pickMultiImage() async {
    lastError = null;
    if (!_canPick) {
      lastError = 'Unsupported platform';
      return [];
    }
    if (debugPickMultiImageHandler != null) {
      return debugPickMultiImageHandler!();
    }

    try {
      final images = await _picker.pickMultiImage(imageQuality: 85);
      return images
          .where((image) => image.path.isNotEmpty)
          .map((image) => File(image.path))
          .toList();
    } catch (e) {
      lastError = e.toString();
      return [];
    }
  }
}
