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
      .thenAnswer((_) async {});
  when(() => historyRepository.getPieceFromHistory(piece.id, null))
      .thenAnswer((_) async => piece);
  when(() => savedNewsRepository.isPieceSaved(piece.id))
      .thenAnswer((_) async => false);
  when(() => savedNewsRepository.savePiece(piece)).thenAnswer((_) async {});

  group('NewsCard and OptionsSheet', () {
    late Widget testWidget;

    // show options sheet
    Future<void> pumpWidgetAndTapMoreIcon(WidgetTester tester) async {
      await tester.pumpWidget(testWidget);
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();
    }

    setUp(() {
      testWidget = getTestWidgetFromInitialWidget(
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
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
    });

    testWidgets('news piece page is opened when card is tapped',
        (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.tap(find.byType(NewsCard));
      await tester.pumpAndSettle();

      expect(find.byType(NewsPiecePage), findsOneWidget);
      expect(find.byType(NewsCard), findsNothing);
    });

    testWidgets('bottom sheet is shown when card is long pressed',
        (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.longPress(find.byType(NewsCard));
      await tester.pumpAndSettle();

      expect(find.byType(OptionsSheet), findsOneWidget);
    });

    testWidgets('bottom sheet is shown when more icon is tapped',
        (tester) async {
      await pumpWidgetAndTapMoreIcon(tester);
      expect(find.byType(OptionsSheet), findsOneWidget);
    });

    testWidgets('bottom sheet is closed when area outside is tapped ',
        (tester) async {
      await pumpWidgetAndTapMoreIcon(tester);
      await tester.tapAt(const Offset(0, 0));
      await tester.pumpAndSettle();

      expect(find.byType(OptionsSheet), findsNothing);
    });

    testWidgets('bottom sheet is closed when tapped on Dismiss button',
        (tester) async {
      await pumpWidgetAndTapMoreIcon(tester);
      await tester.tap(find.text('Dismiss'));
      await tester.pumpAndSettle();

      expect(find.byType(OptionsSheet), findsNothing);
    });

    testWidgets('snackbar message is shown when news piece is saved',
        (tester) async {
      await pumpWidgetAndTapMoreIcon(tester);
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('going to source page works', (tester) async {
      await pumpWidgetAndTapMoreIcon(tester);
      await tester.tap(find.byIcon(Icons.open_in_new));
      await tester.pumpAndSettle();

      expect(find.byType(SourcePage), findsOneWidget);
      expect(find.byType(OptionsSheet), findsNothing);
    });
  });
}
