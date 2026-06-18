import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:haoke_app/application.dart';
import 'package:haoke_app/models/filter_model.dart';
import 'package:haoke_app/providers/auth_provider.dart';
import 'package:haoke_app/providers/locale_provider.dart';
import 'package:haoke_app/utils/logger.dart';
import 'package:provider/provider.dart';

// 程序入口
void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      // 捕获 Flutter framework 层异常（build/layout/paint 等）
      FlutterError.onError = (FlutterErrorDetails details) {
        AppLogger.e('Flutter framework error', details.exception, details.stack);
        if (kDebugMode) {
          FlutterError.presentError(details);
        }
      };

      // 捕获平台层（引擎/原生）未处理异常
      PlatformDispatcher.instance.onError = (error, stack) {
        AppLogger.e('Uncaught platform error', error, stack);
        return true;
      };

      // release 模式下用友好的占位组件替代红屏
      if (!kDebugMode) {
        ErrorWidget.builder = (FlutterErrorDetails details) {
          return const Material(
            child: Center(
              child: Text(
                '页面出错了，请稍后重试',
                style: TextStyle(fontSize: 16, color: Color(0xFF7D8B88)),
              ),
            ),
          );
        };
      }

      // Provider 使用 在入口处挂载Provider
      runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FilterModel()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ],
        child: const Application(),
      ));
    },
    (error, stack) {
      // 捕获 Dart 异步未处理异常
      AppLogger.e('Uncaught zone error', error, stack);
    },
  );
}
