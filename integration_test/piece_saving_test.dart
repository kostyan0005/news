import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:news/main_common.dart' as app;
import 'package:news/modules/news/pages/all.dart';
import 'package:news/modules/news/widgets/news_card.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('news piece saving logic works', testPieceSavingLogic);
}

Future<void> testPieceSavingLogic(WidgetTester tester) async {
  await app.mainCommon();
  await tester.pumpAndSettle();

  // get titles of first two pieces
  final foundPieces = find.byType(NewsCard).evaluate().toList();
  final firstPieceTitle = (foundPieces[0].widget as NewsCard).piece.title;
  final secondPieceTitle = (foundPieces[1].widget as NewsCard).piece.title;

  // save first two pieces
  await _savePiece(tester, 0);
  await _savePiece(tester, 1);

  // go to saved news tab
  if (kIsWeb) {
    // open drawer on web
    await tester.tapAt(const Offset(0, 0));
    await tester.pumpAndSettle();
  }
  await tester.tap(find.byIcon(Icons.star_border));
  await tester.pumpAndSettle();

  // define finders for both saved pieces
  final firstSavedPieceFinder = find.text(firstPieceTitle).hitTestable();
  final secondSavedPieceFinder = find.text(secondPieceTitle).hitTestable();

  // check that two pieces we saved before are the only ones present among saved
  expect(find.byType(SavedNewsPage), findsOneWidget);
  expect(find.byType(NewsCard).hitTestable(), findsNWidgets(2));
  expect(firstSavedPieceFinder, findsOneWidget);
  expect(secondSavedPieceFinder, findsOneWidget);

  // remove first piece from saved
  // its index is 1 because it was saved earlier and thus it's located lower
  await tester.tap(find.byIcon(Icons.more_horiz).hitTestable().at(1));
  await tester.pumpAndSettle();
  await _removePieceFromSaved(tester);

  // check that now one piece is left among saved
  expect(find.byType(NewsCard).hitTestable(), findsOneWidget);
  expect(firstSavedPieceFinder, findsNothing);
  expect(secondSavedPieceFinder, findsOneWidget);

  // skip the rest for web, as next step opens a webview,
  // which causes testing problems on web for some reason
  if (kIsWeb) return;

  // open second piece page
  await tester.tap(secondSavedPieceFinder);
  await tester.pumpAndSettle();
  expect(find.byType(NewsPiecePage), findsOneWidget);

  // remove second piece from saved via its page
  await tester.tap(find.byIcon(Icons.more_horiz).hitTestable());
  await tester.pumpAndSettle();
  await _removePieceFromSaved(tester);

  // go back to saved news page
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();

  // check that no saved pieces are left
  expect(find.byType(SavedNewsPage), findsOneWidget);
  expect(find.byType(NewsCard).hitTestable(), findsNothing);
}

Future<void> _savePiece(WidgetTester tester, int index) async {
  // we use more icon finder, as long-pressing on card itself doesn't work
  // on web because of selectable title
  final moreIconFinder = find.byIcon(Icons.more_horiz).at(index);

  // open options sheet
  await tester.tap(moreIconFinder);
  await tester.pumpAndSettle();

  // tap save icon
  await tester.tap(find.byIcon(Icons.star_border).hitTestable());
  await tester.pumpAndSettle();

  // wait for snackbar to hide
  await _waitForSnackBar(tester);
}

Future<void> _removePieceFromSaved(WidgetTester tester) async {
  // tap remove icon
  await tester.tap(find.byIcon(Icons.delete_outlined));
  await tester.pumpAndSettle();

  // wait for snackbar to hide
  await _waitForSnackBar(tester);
}

Future<void> _waitForSnackBar(WidgetTester tester) async {
  // check that snackbar is shown for 2 sec then hidden
  expect(find.byType(SnackBar), findsOneWidget);

  await Future.delayed(const Duration(seconds: 2));
  await tester.pumpAndSettle();

  expect(find.byType(SnackBar), findsNothing);
}
