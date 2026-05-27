import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:haoke_rent/config/app_config.dart';
import 'package:haoke_rent/config/app_theme.dart';
import 'package:haoke_rent/pages/splash/splash_page.dart';
import 'package:haoke_rent/routes.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final FluroRouter router = FluroRouter();
    Routes.configureRoutes(router);

    return MaterialApp(
      title: AppConfig.appName,
      theme: AppTheme.lightTheme,
      scrollBehavior:
          const MaterialScrollBehavior().copyWith(overscroll: false),
      home: const SplashPage(),
      onGenerateRoute: router.generator,
      debugShowCheckedModeBanner: false,
    );
  }
}
