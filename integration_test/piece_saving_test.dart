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

/// Fully tests piece saving logic.
Future<void> testPieceSavingLogic(WidgetTester tester) async {
  await app.mainCommon();
  await tester.pumpAndSettle();

  // Get titles of first two pieces.
  final foundPieces = find.byType(NewsCard).evaluate().toList();
  final firstPieceTitle = (foundPieces[0].widget as NewsCard).piece.title;
  final secondPieceTitle = (foundPieces[1].widget as NewsCard).piece.title;

  // Save first two pieces.
  await _savePiece(tester, 0);
  await _savePiece(tester, 1);

  // Go to saved news tab.
  if (kIsWeb) {
    // Open drawer on web.
    await tester.tapAt(const Offset(0, 0));
    await tester.pumpAndSettle();
  }
  await tester.tap(find.byIcon(Icons.star_border));
  await tester.pumpAndSettle();

  // Define finders for both saved pieces.
  final firstSavedPieceFinder = find.text(firstPieceTitle).hitTestable();
  final secondSavedPieceFinder = find.text(secondPieceTitle).hitTestable();

  // Check that two pieces we saved before are the only ones present among saved.
  expect(find.byType(SavedNewsPage), findsOneWidget);
  expect(find.byType(NewsCard).hitTestable(), findsNWidgets(2));
  expect(firstSavedPieceFinder, findsOneWidget);
  expect(secondSavedPieceFinder, findsOneWidget);

  // Remove first piece from saved.
  // Its index is 1 because it was saved earlier and thus it is located lower.
  await tester.tap(find.byIcon(Icons.more_horiz).hitTestable().at(1));
  await tester.pumpAndSettle();
  await _removePieceFromSaved(tester);

  // Check that now one piece is left among saved.
  expect(find.byType(NewsCard).hitTestable(), findsOneWidget);
  expect(firstSavedPieceFinder, findsNothing);
  expect(secondSavedPieceFinder, findsOneWidget);

  // Skip the rest for web, as next step opens a webview, which causes testing
  // problems on web for some reason.
  if (kIsWeb) return;

  // Open second piece page.
  await tester.tap(secondSavedPieceFinder);
  await tester.pumpAndSettle();
  expect(find.byType(NewsPiecePage), findsOneWidget);

  // Remove second piece from saved via its page.
  await tester.tap(find.byIcon(Icons.more_horiz).hitTestable());
  await tester.pumpAndSettle();
  await _removePieceFromSaved(tester);

  // Go back to saved news page.
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();

  // Check that no saved pieces are left.
  expect(find.byType(SavedNewsPage), findsOneWidget);
  expect(find.byType(NewsCard).hitTestable(), findsNothing);
}

/// Saves the news piece via the options sheet.
///
/// This news piece has a particular [index] in the news list.
Future<void> _savePiece(WidgetTester tester, int index) async {
  // We use more icon finder, as long-pressing on card itself doesn't work
  // on web because of selectable title.
  final moreIconFinder = find.byIcon(Icons.more_horiz).at(index);

  // Open options sheet.
  await tester.tap(moreIconFinder);
  await tester.pumpAndSettle();

  // Tap save icon.
  await tester.tap(find.byIcon(Icons.star_border).hitTestable());
  await tester.pumpAndSettle();

  // Wait for snackbar to hide.
  await _waitForSnackBar(tester);
}

/// Removes the piece from saved news by tapping on delete icon.
Future<void> _removePieceFromSaved(WidgetTester tester) async {
  // Tap remove icon.
  await tester.tap(find.byIcon(Icons.delete_outlined));
  await tester.pumpAndSettle();

  // Wait for snackbar to hide.
  await _waitForSnackBar(tester);
}

/// Checks that snackbar is shown for 2 sec then hidden.
Future<void> _waitForSnackBar(WidgetTester tester) async {
  expect(find.byType(SnackBar), findsOneWidget);

  await Future.delayed(const Duration(seconds: 2));
  await tester.pumpAndSettle();

  expect(find.byType(SnackBar), findsNothing);
}
