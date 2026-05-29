import 'package:flutter_test/flutter_test.dart';
import 'package:haoke_rent/application.dart';
import 'package:haoke_rent/models/filter_model.dart';
import 'package:haoke_rent/providers/auth_provider.dart';
import 'package:haoke_rent/providers/locale_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('应用可以正常启动并显示启动页', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FilterModel()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ],
        child: const Application(),
      ),
    );

    await tester.pump();

    expect(find.text('好客租房'), findsOneWidget);
    expect(find.text('让租房变得简单'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });
}
