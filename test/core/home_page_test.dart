import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/modules/news/repositories/all.dart';
import 'package:news/modules/profile/models/user_settings_model.dart';
import 'package:news/modules/profile/repositories/user_settings_repository.dart';
import 'package:news/utils/rss_utils.dart';

import '../test_utils/all.dart';

void main() async {
  await loadTranslations();

  final settingsRepository = MockUserSettingsRepository();
  final newsSearchRepository = MockNewsSearchRepository();
  final subscriptionsRepository = MockSubscriptionsRepository();
  final savedNewsRepository = MockSavedNewsRepository();

  when(() => settingsRepository.getSettingsStream()).thenAnswer((_) =>
      Stream.fromFuture(Future.value(const UserSettings(locale: 'en_US'))));
  when(() => newsSearchRepository.getNewsFromRssUrl(getLatestNewsUrl('en_US')))
      .thenAnswer((_) => Future.value([]));
  when(() => subscriptionsRepository.getSubscriptionsStream())
      .thenAnswer((_) => Stream.fromFuture(Future.value([])));
  when(() => savedNewsRepository.getSavedNewsStream())
      .thenAnswer((_) => Stream.fromFuture(Future.value([])));

  Finder findBottomNavBarWithCurrentTab(String tabName) =>
      find.byWidgetPredicate((widget) =>
          widget is BottomNavigationBar &&
          widget.items.length == 3 &&
          widget.items[widget.currentIndex].label == tabName);

  Finder findBottomNavBarItem(String tabName) => find.byTooltip(tabName);

  Finder findAppBarWithTitle(String title) => find.byWidgetPredicate((widget) =>
      widget is SliverAppBar && (widget.title as Text).data == title);

  Finder findSearchButton(String tabName) =>
      find.byKey(ValueKey('search_button_$tabName'));

  Finder findProfileButton(String tabName) =>
      find.byKey(ValueKey('profile_button_$tabName'));

  group('HomePage', () {
    late Widget testWidget;

    setUp(() {
      testWidget = getTestWidget(
        overrides: [
          userSettingsRepositoryProvider.overrideWithValue(settingsRepository),
          newsSearchRepositoryProvider.overrideWithValue(newsSearchRepository),
          subscriptionsRepositoryProvider
              .overrideWithValue(subscriptionsRepository),
          savedNewsRepositoryProvider.overrideWithValue(savedNewsRepository),
          signInStatusStreamProvider.overrideWithValue(
              const AsyncValue.data(SignInStatus(isSignedIn: false))),
        ],
      );
    });

    testWidgets('initial state is correct', (tester) async {
      await tester.pumpWidget(testWidget);

      const tabName = 'Headlines';
      expect(findBottomNavBarWithCurrentTab(tabName), findsOneWidget);
      expect(findBottomNavBarItem(tabName), findsOneWidget);
      expect(findAppBarWithTitle(tabName), findsOneWidget);
      expect(findSearchButton(tabName), findsOneWidget);
      expect(findProfileButton(tabName), findsOneWidget);
    });

    testWidgets('can switch to subscriptions tab', (tester) async {
      await tester.pumpWidget(testWidget);

      const tabName = 'Subscriptions';
      await tester.tap(findBottomNavBarItem(tabName));
      await tester.pump();

      expect(findBottomNavBarWithCurrentTab(tabName), findsOneWidget);
      expect(findAppBarWithTitle(tabName), findsOneWidget);
    });

    testWidgets('can switch to saved news tab', (tester) async {
      await tester.pumpWidget(testWidget);

      const tabName = 'Saved news';
      await tester.tap(findBottomNavBarItem(tabName));
      await tester.pump();

      expect(findBottomNavBarWithCurrentTab(tabName), findsOneWidget);
      expect(findAppBarWithTitle(tabName), findsOneWidget);
    });

    testWidgets('can go to search text page', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.tap(findSearchButton('Headlines'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('can open and close profile dialog', (tester) async {
      await tester.pumpWidget(testWidget);

      await tester.tap(findProfileButton('Headlines'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('close_profile_dialog')));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });
  });
}
