import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:haoke_rent/config/app_config.dart';
import 'package:haoke_rent/pages/splash/splash_page.dart';
import 'package:haoke_rent/routes.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final FluroRouter router = FluroRouter();
    Routes.configureRoutes(router);

    final app = MaterialApp(
      title: AppConfig.appName,
      theme: ThemeData(
        primarySwatch: Colors.red,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.red),
      ),
      // 应用启动时进入 SplashPage
      home: const SplashPage(),
      onGenerateRoute: router.generator,
    );
    return app;
  }
}
