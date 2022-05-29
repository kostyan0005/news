import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/modules/news/repositories/news_search_repository.dart';
import 'package:news/modules/news/widgets/rss_news_list.dart';
import 'package:news/widgets/indicators.dart';

import '../../../test_utils/all.dart';

void main() async {
  await loadTranslations();

  final newsSearchRepository = MockNewsSearchRepository();

  group('RssNewsList', () {
    late Widget testWidget;

    setUp(() {
      testWidget = getTestWidgetFromInitialWidget(
        initialWidget: const RssNewsList(''),
        overrides: [
          newsSearchRepositoryProvider.overrideWithValue(newsSearchRepository),
        ],
      );
    });

    testWidgets('indicates when initial loading happens', (tester) async {
      when(() => newsSearchRepository.getNewsFromRssUrl(''))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(testWidget);
      expect(find.byType(LoadingIndicator), findsOneWidget);
    });

    testWidgets('indicates when no elements are present', (tester) async {
      when(() => newsSearchRepository.getNewsFromRssUrl(''))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(testWidget);
      await tester.pump();

      expect(find.text('No news found'), findsOneWidget);
    });

    testWidgets('indicates when error occurred while fetching news',
        (tester) async {
      when(() => newsSearchRepository.getNewsFromRssUrl(''))
          .thenAnswer((_) async => throw Exception());

      await tester.pumpWidget(testWidget);
      await tester.pump();

      expect(find.byType(ErrorIndicator), findsOneWidget);
    });

    testWidgets('scrolling works', (tester) async {
      when(() => newsSearchRepository.getNewsFromRssUrl(''))
          .thenAnswer((_) async => generateTestPieceListFromTitle('Piece'));

      await tester.pumpWidget(testWidget);
      await tester.pump();
      expect(find.text('Piece 0'), findsOneWidget);
      expect(find.text('Piece 19'), findsNothing);

      await tester.scrollUntilVisible(find.text('Piece 19'), 500);
      expect(find.text('Piece 19'), findsOneWidget);
      expect(find.text('Piece 0'), findsNothing);

      await tester.scrollUntilVisible(find.text('Piece 0'), -500);
      expect(find.text('Piece 0'), findsOneWidget);
      expect(find.text('Piece 19'), findsNothing);
    });

    testWidgets(
      'refresh indicator is shown when scrolled up and hidden when released',
      (tester) async {
        when(() => newsSearchRepository.getNewsFromRssUrl(''))
            .thenAnswer((_) async => generateTestPieceListFromTitle('Piece'));

        await tester.pumpWidget(testWidget);
        await tester.pump();

        final refreshIndicator = find.byType(CircularProgressIndicator);
        await tester.scrollUntilVisible(refreshIndicator, -30);
        expect(refreshIndicator, findsOneWidget);

        await tester.pump();
        expect(refreshIndicator, findsNothing);
      },
    );
  });
}
