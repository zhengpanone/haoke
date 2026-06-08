import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:haoke_app/utils/image_picker_util.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    ImagePickerUtil.debugIsAndroidOverride = true;
  });

  tearDown(() {
    ImagePickerUtil.debugIsAndroidOverride = null;
    ImagePickerUtil.debugPickImageHandler = null;
    ImagePickerUtil.debugPickMultiImageHandler = null;
  });

  group('pickImage', () {
    test('returns picked image file', () async {
      ImagePickerUtil.debugPickImageHandler = () async =>
          File('/path/to/image.png');

      final file = await ImagePickerUtil.pickImage();

      expect(file, isNotNull);
      expect(file!.path, '/path/to/image.png');
    });

    test('returns null when picker returns null', () async {
      ImagePickerUtil.debugPickImageHandler = () async => null;

      final file = await ImagePickerUtil.pickImage();

      expect(file, isNull);
    });

    test('returns null when picking is disabled', () async {
      ImagePickerUtil.debugIsAndroidOverride = false;
      ImagePickerUtil.debugPickImageHandler = () async =>
          File('/path/to/image.png');

      final file = await ImagePickerUtil.pickImage();

      expect(file, isNull);
    });
  });

  group('pickMultiImage', () {
    test('returns picked image files', () async {
      ImagePickerUtil.debugPickMultiImageHandler = () async => [
        File('/path/to/image1.png'),
        File('/path/to/image2.png'),
      ];

      final files = await ImagePickerUtil.pickMultiImage();

      expect(files.map((file) => file.path), [
        '/path/to/image1.png',
        '/path/to/image2.png',
      ]);
    });

    test('returns empty list when picker returns empty list', () async {
      ImagePickerUtil.debugPickMultiImageHandler = () async => [];

      final files = await ImagePickerUtil.pickMultiImage();

      expect(files, isEmpty);
    });

    test('returns empty list when picking is disabled', () async {
      ImagePickerUtil.debugIsAndroidOverride = false;
      ImagePickerUtil.debugPickMultiImageHandler = () async => [
        File('/path/to/image.png'),
      ];

      final files = await ImagePickerUtil.pickMultiImage();

      expect(files, isEmpty);
    });
  });
}
