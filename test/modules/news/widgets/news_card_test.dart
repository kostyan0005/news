import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/pages/all.dart';
import 'package:news/modules/news/repositories/all.dart';
import 'package:news/modules/news/widgets/news_card.dart';
import 'package:news/modules/news/widgets/options_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../test_utils/all.dart';

void main() async {
  await loadTranslations();

  final piece = NewsPiece(
    id: '13002787341645408749',
    link: 'https://news.google.com/__i/rss/rd/articles'
        '/CBMiNmh0dHBzOi8vd3d3LnByYXZkYS5jb20udWEvcnV',
    title: 'Байден и Путин согласились на участие '
        'в саммите по вопросам безопасности',
    sourceName: 'Украинская правда',
    sourceLink: 'https://www.pravda.com.ua',
    pubDate: DateTime.utc(2022, 02, 21, 01, 59, 09),
    isSaved: false,
  );

  final historyRepository = MockHistoryRepository();
  final savedNewsRepository = MockSavedNewsRepository();

  when(() => historyRepository.addPieceToHistory(piece))
      .thenAnswer((_) => Future.value(null));
  when(() => historyRepository.getPieceFromHistory(piece.id, null))
      .thenAnswer((_) => Future.value(piece));
  when(() => savedNewsRepository.isPieceSaved(piece.id))
      .thenAnswer((_) => Future.value(false));

  Finder findMoreIcon() => find.byWidgetPredicate(
      (widget) => widget is Icon && widget.icon == Icons.more_horiz);

  group('NewsCard', () {
    late Widget testWidget;

    setUp(() {
      testWidget = getTestWidget(
        initialWidget: NewsCard(piece),
        overrides: [
          historyRepositoryProvider.overrideWithValue(historyRepository),
          savedNewsRepositoryProvider.overrideWithValue(savedNewsRepository),
        ],
      );
    });

    testWidgets('required card elements are present', (tester) async {
      await tester.pumpWidget(testWidget);

      final title = find.byWidgetPredicate(
          (widget) => widget is Text && widget.data == piece.title);
      expect(title, findsOneWidget);

      final sourceDotTime = find.byWidgetPredicate((widget) =>
          widget is Text &&
          widget.data ==
              '${piece.sourceName} · ${timeago.format(piece.pubDate)}');

      expect(title, findsOneWidget);
      expect(sourceDotTime, findsOneWidget);
      expect(findMoreIcon(), findsOneWidget);
    });

    testWidgets(
      'news piece page is opened when card is tapped',
      (tester) async {
        await tester.pumpWidget(testWidget);
        await tester.tap(find.byType(NewsCard));
        await tester.pumpAndSettle();

        expect(find.byType(NewsPiecePage), findsOneWidget);
        expect(find.byType(NewsCard), findsNothing);
      },
    );

    testWidgets(
      'bottom sheet is shown when more icon is tapped',
      (tester) async {
        await tester.pumpWidget(testWidget);
        await tester.tap(findMoreIcon());
        await tester.pumpAndSettle();

        expect(find.byType(OptionsSheet), findsOneWidget);
      },
    );

    testWidgets(
      'bottom sheet is shown when card is long pressed',
      (tester) async {
        await tester.pumpWidget(testWidget);
        await tester.longPress(find.byType(NewsCard));
        await tester.pumpAndSettle();

        expect(find.byType(OptionsSheet), findsOneWidget);
      },
    );

    // todo: add further tests
  });
}
