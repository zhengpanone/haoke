import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  // 支持传入 picker，默认使用 ImagePicker()
  static ImagePicker picker = ImagePicker();

  /// 选择单张图片
  /// [source] 默认相册，可传 ImageSource.camera
  /// 返回 null 表示用户取消选择
  static Future<File?> pickImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final XFile? image = await picker.pickImage(source: source);
      if (image == null) return null;
      return File(image.path);
    } catch (e) {
      // 处理异常，比如权限不足
      print('pickImage error: $e');
      return null;
    }
  }

  /// 选择多张图片
  /// 返回空列表表示用户取消选择
  static Future<List<File>> pickMultiImage() async {
    try {
      final List<XFile>? images = await picker.pickMultiImage();
      if (images == null || images.isEmpty) return [];
      return images.map((xfile) => File(xfile.path)).toList();
    } catch (e) {
      print('pickMultiImage error: $e');
      return [];
    }
  }
}

// // 单张图片
// File? file = await ImagePickerUtil.pickImage();
// if (file != null) {
//   print('选择了图片: ${file.path}');
// }

// // 多张图片
// List<File> files = await ImagePickerUtil.pickMultiImage();
// print('选择了 ${files.length} 张图片');
