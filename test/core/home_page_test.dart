import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/modules/news/repositories/all.dart';
import 'package:news/modules/profile/models/user_settings_model.dart';
import 'package:news/modules/profile/repositories/user_settings_repository.dart';
import 'package:news/router.dart';
import 'package:news/utils/rss_utils.dart';

import '../test_utils/all.dart';

void main() async {
  await loadTranslations();

  late MockUserSettingsRepository settingsRepository;
  late MockNewsSearchRepository newsSearchRepository;
  late MockSubscriptionsRepository subscriptionsRepository;
  late MockSavedNewsRepository savedNewsRepository;
  late Widget testWidget;

  setUp(() {
    settingsRepository = MockUserSettingsRepository();
    newsSearchRepository = MockNewsSearchRepository();
    subscriptionsRepository = MockSubscriptionsRepository();
    savedNewsRepository = MockSavedNewsRepository();

    testWidget = ProviderScope(
      overrides: [
        userSettingsRepositoryProvider.overrideWithValue(settingsRepository),
        newsSearchRepositoryProvider.overrideWithValue(newsSearchRepository),
        subscriptionsRepositoryProvider
            .overrideWithValue(subscriptionsRepository),
        savedNewsRepositoryProvider.overrideWithValue(savedNewsRepository),
      ],
      child: MaterialApp.router(
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
      ),
    );

    // arrange
    when(() => settingsRepository.getSettingsStream()).thenAnswer((_) =>
        Stream.fromFuture(Future.value(const UserSettings(locale: 'en_US'))));
    when(() =>
            newsSearchRepository.getNewsFromRssUrl(getLatestNewsUrl('en_US')))
        .thenAnswer((_) => Future.value([]));
    when(() => subscriptionsRepository.getSubscriptionsStream())
        .thenAnswer((_) => Stream.fromFuture(Future.value([])));
    when(() => savedNewsRepository.getSavedNewsStream())
        .thenAnswer((_) => Stream.fromFuture(Future.value([])));
  });

  Finder findBottomNavBarWithCurrentTab(String tabName) =>
      find.byWidgetPredicate((widget) =>
          widget is BottomNavigationBar &&
          widget.items.length == 3 &&
          widget.items[widget.currentIndex].label == tabName);

  Finder findAppBarWithTitle(String title) => find.byWidgetPredicate((widget) =>
      widget is SliverAppBar && (widget.title as Text).data == title);

  Finder findSearchButton(String tabName) =>
      find.byKey(ValueKey('search_button_$tabName'));

  Finder findProfileButton(String tabName) =>
      find.byKey(ValueKey('profile_button_$tabName'));

  group('HomePage', () {
    testWidgets('initial state is correct', (tester) async {
      await tester.pumpWidget(testWidget);

      const tabName = 'Headlines';
      expect(findBottomNavBarWithCurrentTab(tabName), findsOneWidget);
      expect(findAppBarWithTitle(tabName), findsOneWidget);
      expect(findSearchButton(tabName), findsOneWidget);
      expect(findProfileButton(tabName), findsOneWidget);
    });
  });
}
