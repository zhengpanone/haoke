import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:haoke_app/config/app_config.dart';
import 'package:haoke_app/config/app_theme.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/pages/splash/splash_page.dart';
import 'package:haoke_app/providers/locale_provider.dart';
import 'package:haoke_app/routes.dart';
import 'package:provider/provider.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final FluroRouter router = FluroRouter();
    Routes.configureRoutes(router);

    return MaterialApp(
      title: AppConfig.appName,
      theme: AppTheme.lightTheme,
      scrollBehavior:
          const MaterialScrollBehavior().copyWith(overscroll: false),
      locale: localeProvider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashPage(),
      onGenerateRoute: router.generator,
      debugShowCheckedModeBanner: false,
    );
  }
}
