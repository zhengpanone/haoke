import 'package:flutter/material.dart';
import 'package:haoke_rent/application.dart';
import 'package:haoke_rent/models/filter_model.dart';
import 'package:haoke_rent/providers/auth_provider.dart';
import 'package:haoke_rent/providers/locale_provider.dart';
import 'package:provider/provider.dart';

// 程序入口
void main() {
  // 2. Provider使用 在入口处挂载Provider
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => FilterModel()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ],
    child: const Application(),
  ));
}
