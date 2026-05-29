import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haoke_rent/utils/image_picker_util.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('com.example.haoke_rent/image_picker');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    ImagePickerUtil.debugIsAndroidOverride = true;
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    ImagePickerUtil.debugIsAndroidOverride = null;
  });

  void mockImagePickerChannel(
      Future<dynamic> Function(MethodCall call) handler) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) {
      calls.add(call);
      return handler(call);
    });
  }

  group('pickImage', () {
    test('通道返回图片路径时返回 File', () async {
      mockImagePickerChannel((call) async => '/path/to/image.png');

      final file = await ImagePickerUtil.pickImage();

      expect(file, isNotNull);
      expect(file!.path, '/path/to/image.png');
      expect(calls, hasLength(1));
      expect(calls.single.method, 'pickImage');
    });

    test('通道返回 null 时返回 null', () async {
      mockImagePickerChannel((call) async => null);

      final file = await ImagePickerUtil.pickImage();

      expect(file, isNull);
      expect(calls.single.method, 'pickImage');
    });

    test('通道返回空路径时返回 null', () async {
      mockImagePickerChannel((call) async => '');

      final file = await ImagePickerUtil.pickImage();

      expect(file, isNull);
      expect(calls.single.method, 'pickImage');
    });

    test('通道抛出异常时返回 null', () async {
      mockImagePickerChannel((call) async {
        throw PlatformException(code: 'PICK_FAILED');
      });

      final file = await ImagePickerUtil.pickImage();

      expect(file, isNull);
      expect(calls.single.method, 'pickImage');
    });

    test('非 Android 平台直接返回 null 且不调用通道', () async {
      ImagePickerUtil.debugIsAndroidOverride = false;
      mockImagePickerChannel((call) async => '/path/to/image.png');

      final file = await ImagePickerUtil.pickImage();

      expect(file, isNull);
      expect(calls, isEmpty);
    });
  });

  group('pickMultiImage', () {
    test('通道返回路径列表时返回 File 列表', () async {
      mockImagePickerChannel(
        (call) async => ['/path/to/image1.png', '/path/to/image2.png'],
      );

      final files = await ImagePickerUtil.pickMultiImage();

      expect(files.map((file) => file.path), [
        '/path/to/image1.png',
        '/path/to/image2.png',
      ]);
      expect(calls, hasLength(1));
      expect(calls.single.method, 'pickMultiImage');
    });

    test('过滤空路径和非字符串值', () async {
      mockImagePickerChannel(
        (call) async => ['/path/to/image.png', '', 1, null],
      );

      final files = await ImagePickerUtil.pickMultiImage();

      expect(files.map((file) => file.path), ['/path/to/image.png']);
      expect(calls.single.method, 'pickMultiImage');
    });

    test('通道返回 null 时返回空列表', () async {
      mockImagePickerChannel((call) async => null);

      final files = await ImagePickerUtil.pickMultiImage();

      expect(files, isEmpty);
      expect(calls.single.method, 'pickMultiImage');
    });

    test('通道返回空列表时返回空列表', () async {
      mockImagePickerChannel((call) async => []);

      final files = await ImagePickerUtil.pickMultiImage();

      expect(files, isEmpty);
      expect(calls.single.method, 'pickMultiImage');
    });

    test('通道抛出异常时返回空列表', () async {
      mockImagePickerChannel((call) async {
        throw PlatformException(code: 'PICK_FAILED');
      });

      final files = await ImagePickerUtil.pickMultiImage();

      expect(files, isEmpty);
      expect(calls.single.method, 'pickMultiImage');
    });

    test('非 Android 平台直接返回空列表且不调用通道', () async {
      ImagePickerUtil.debugIsAndroidOverride = false;
      mockImagePickerChannel((call) async => ['/path/to/image.png']);

      final files = await ImagePickerUtil.pickMultiImage();

      expect(files, isEmpty);
      expect(calls, isEmpty);
    });
  });
}
