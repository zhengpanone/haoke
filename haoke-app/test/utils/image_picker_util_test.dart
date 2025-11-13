import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:haoke_rent/utils/image_picker_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

// 模拟 ImagePicker
class MockImagePicker extends Mock implements ImagePicker {}

// 模拟 XFile
class MockXFile extends Mock implements XFile {}

void main() {
  // 注册枚举类型 fallback，mocktail 要求
  setUpAll(() {
    registerFallbackValue(ImageSource.gallery);
  });

  late MockImagePicker mockPicker;

  setUp(() {
    mockPicker = MockImagePicker();
    // 注入 mock
    ImagePickerUtil.picker = mockPicker;
  });

  test('pickImage 返回 File', () async {
    final mockFile = MockXFile();
    when(() => mockFile.path).thenReturn('/path/to/image.png');
    when(
      () => mockPicker.pickImage(source: any(named: 'source')),
    ).thenAnswer((_) async => mockFile);

    final file = await ImagePickerUtil.pickImage();
    expect(file, isA<File>());
    expect(file!.path, '/path/to/image.png');
  });

  test('pickImage 用户取消返回 null', () async {
    when(
      () => mockPicker.pickImage(source: any(named: 'source')),
    ).thenAnswer((_) async => null);

    final file = await ImagePickerUtil.pickImage();
    expect(file, isNull);
  });

  test('pickMultiImage 返回 File 列表', () async {
    final mockFile1 = MockXFile();
    final mockFile2 = MockXFile();
    when(() => mockFile1.path).thenReturn('/path/to/image1.png');
    when(() => mockFile2.path).thenReturn('/path/to/image2.png');

    when(
      () => mockPicker.pickMultiImage(),
    ).thenAnswer((_) async => [mockFile1, mockFile2]);

    final files = await ImagePickerUtil.pickMultiImage();
    expect(files.length, 2);
    expect(files[0].path, '/path/to/image1.png');
    expect(files[1].path, '/path/to/image2.png');
  });

  test('pickMultiImage 用户取消返回空列表', () async {
    when(() => mockPicker.pickMultiImage()).thenAnswer((_) async => []);

    final files = await ImagePickerUtil.pickMultiImage();
    expect(files, isEmpty);
  });
}
