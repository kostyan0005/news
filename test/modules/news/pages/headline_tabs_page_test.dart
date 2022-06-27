import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/modules/news/models/headline_enum.dart';
import 'package:news/modules/news/repositories/all.dart';
import 'package:news/modules/profile/models/user_settings_model.dart';
import 'package:news/modules/profile/repositories/user_settings_repository.dart';

import '../../../test_utils/all.dart';

void main() async {
  await loadTranslations();

  final settingsRepository = MockUserSettingsRepository();
  final newsSearchRepository = MockNewsSearchRepository();

  when(() => settingsRepository.getSettingsStream()).thenAnswer((_) =>
      Stream.fromFuture(Future.value(const UserSettings(locale: 'en_US'))));

  for (final headline in Headline.values) {
    final headlineRssUrl = headline.getRssUrl('en_US');
    final headlineNewsList = generateTestPieceListFromTitle(headline.topic);
    when(() => newsSearchRepository.getNewsFromRssUrl(headlineRssUrl))
        .thenAnswer((_) async => headlineNewsList);
  }

  Finder findTabBarWithCurrentIndex(int index) => find.byWidgetPredicate((w) =>
      w is TabBar &&
      w.controller!.index == index &&
      w.tabs.length == Headline.values.length);
  Finder findTab(Headline headline) => find.text(headline.getTitle('en_US'));
  Finder findNewsListItem(Headline headline) =>
      find.text('${headline.topic} 0');
  int indexOf(Headline headline) => Headline.values.indexOf(headline);

  group('HeadlineTabsPage', () {
    late Widget testWidget;

    setUp(() {
      testWidget = getTestWidgetFromInitialLocation(
        initialLocation: '/',
        overrides: [
          userSettingsRepositoryProvider.overrideWithValue(settingsRepository),
          newsSearchRepositoryProvider.overrideWithValue(newsSearchRepository),
          signInStatusStreamProvider.overrideWithValue(
              const AsyncValue.data(SignInStatus(isSignedIn: false))),
        ],
      );
    });

    testWidgets('initial tab and the number of tabs are correct',
        (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      const latest = Headline.latest;
      expect(findTabBarWithCurrentIndex(indexOf(latest)), findsOneWidget);
      expect(findNewsListItem(latest), findsOneWidget);
    });

    testWidgets('tabs can be switched', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      const nation = Headline.nation;
      await tester.tap(findTab(nation));
      await tester.pumpAndSettle();

      expect(findTabBarWithCurrentIndex(indexOf(nation)), findsOneWidget);
      expect(findNewsListItem(nation), findsOneWidget);

      const business = Headline.business;
      await tester.tap(findTab(business));
      await tester.pumpAndSettle();

      expect(findTabBarWithCurrentIndex(indexOf(business)), findsOneWidget);
      expect(findNewsListItem(business), findsOneWidget);

      const latest = Headline.latest;
      await tester.tap(findTab(latest));
      await tester.pumpAndSettle();

      expect(findTabBarWithCurrentIndex(indexOf(latest)), findsOneWidget);
      expect(findNewsListItem(latest), findsOneWidget);
    });

    testWidgets('can scroll the tab bar and switch to tabs located further',
        (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      const health = Headline.health;
      final healthTab = findTab(health);
      await tester.ensureVisible(healthTab);
      await tester.tap(healthTab);
      await tester.pumpAndSettle();

      expect(findTabBarWithCurrentIndex(indexOf(health)), findsOneWidget);
      expect(findNewsListItem(health), findsOneWidget);
    });
  });
}
