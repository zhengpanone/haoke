import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haoke_app/l10n/app_localizations.dart';
import 'package:haoke_app/pages/home/tab_profile/function_button.dart';
import 'package:haoke_app/pages/home/tab_profile/function_button_widget.dart';
import 'package:haoke_app/pages/my_orders/index.dart';
import 'package:haoke_app/routes.dart';

void main() {
  testWidgets('my orders entry opens MyOrdersPage', (tester) async {
    final router = FluroRouter();
    Routes.configureRoutes(router);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [AppLocalizations.delegate],
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: router.generator,
        home: const Scaffold(body: FunctionButton()),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byType(FunctionButtonWidget).at(1));
    await tester.pumpAndSettle();

    expect(find.byType(MyOrdersPage), findsOneWidget);
  });

  testWidgets('my orders icon itself opens MyOrdersPage', (tester) async {
    final router = FluroRouter();
    Routes.configureRoutes(router);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [AppLocalizations.delegate],
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: router.generator,
        home: const Scaffold(body: FunctionButton()),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.receipt_long_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(MyOrdersPage), findsOneWidget);
  });
}
