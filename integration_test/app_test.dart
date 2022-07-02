import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:news/core/home_tab_enum.dart';
import 'package:news/main.dart' as app;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('initial state is correct', (tester) async {
    app.main();
    await Future.delayed(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    const tab = HomeTab.headlines;
    final bottomNavBarFinder = find.byWidgetPredicate((w) =>
        w is PersistentTabView &&
        w.items![w.controller!.index].title == tab.title);

    expect(bottomNavBarFinder, findsOneWidget);
    expect(find.byIcon(tab.icon), findsOneWidget);
    expect(find.byType(SliverAppBar), findsOneWidget);
    expect(find.text(tab.title), findsNWidgets(2));
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byKey(const ValueKey('profileButton')), findsOneWidget);
  });
}
