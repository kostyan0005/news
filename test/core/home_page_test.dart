import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/core/home_tab_enum.dart';
import 'package:news/modules/news/repositories/all.dart';
import 'package:news/modules/profile/models/user_settings_model.dart';
import 'package:news/modules/profile/repositories/user_settings_repository.dart';
import 'package:news/utils/rss_utils.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

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
      .thenAnswer((_) async => []);
  when(() => subscriptionsRepository.getSubscriptionsStream())
      .thenAnswer((_) => Stream.fromFuture(Future.value([])));
  when(() => savedNewsRepository.getSavedNewsStream())
      .thenAnswer((_) => Stream.fromFuture(Future.value([])));

  Finder findBottomNavBarWithCurrentTab(HomeTab tab) =>
      find.byWidgetPredicate((w) =>
          w is PersistentTabView &&
          w.items![w.controller!.index].title == tab.title);

  Finder findProfileButton() => find.byKey(const ValueKey('profileButton'));

  group('HomePage', () {
    late Widget testWidget;

    setUp(() {
      testWidget = getTestWidgetFromInitialLocation(
        initialLocation: '/',
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

      const tab = HomeTab.headlines;
      expect(findBottomNavBarWithCurrentTab(tab), findsOneWidget);
      expect(find.byIcon(tab.icon), findsOneWidget);
      expect(find.byType(SliverAppBar), findsOneWidget);
      expect(find.text(tab.title), findsNWidgets(2));
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(findProfileButton(), findsOneWidget);
    });

    testWidgets('can switch to subscriptions tab', (tester) async {
      await tester.pumpWidget(testWidget);

      const tab = HomeTab.subscriptions;
      await tester.tap(find.byIcon(tab.icon));
      await tester.pump();

      expect(findBottomNavBarWithCurrentTab(tab), findsOneWidget);
      expect(find.text(tab.title), findsNWidgets(2));
    });

    testWidgets('can switch to saved news tab', (tester) async {
      await tester.pumpWidget(testWidget);

      const tab = HomeTab.savedNews;
      await tester.tap(find.byIcon(tab.icon));
      await tester.pump();

      expect(findBottomNavBarWithCurrentTab(tab), findsOneWidget);
      expect(find.text(tab.title), findsNWidgets(2));
    });

    testWidgets('can go to search text page', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('can open and close profile dialog', (tester) async {
      await tester.pumpWidget(testWidget);

      await tester.tap(findProfileButton());
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets(
      'app bar is hidden when scrolled down and shown back when scrolled up',
      (tester) async {
        final testNewsList = generateTestPieceListFromTitle('Piece');
        when(() => savedNewsRepository.getSavedNewsStream())
            .thenAnswer((_) => Stream.fromFuture(Future.value(testNewsList)));

        await tester.pumpWidget(testWidget);
        await tester.tap(find.byIcon(HomeTab.savedNews.icon));
        await tester.pumpAndSettle();

        // App bar is shown initially.
        expect(find.byType(SliverAppBar), findsOneWidget);

        // App bar is hidden after scrolling down.
        await tester.scrollUntilVisible(find.text('Piece 19'), 500,
            scrollable: find.byType(Scrollable).first);
        expect(find.byType(SliverAppBar), findsNothing);

        // App bar is shown again after scrolling up.
        await tester.scrollUntilVisible(find.text('Piece 0'), -500,
            scrollable: find.byType(Scrollable).first);
        expect(find.byType(SliverAppBar), findsOneWidget);
      },
    );
  });
}
