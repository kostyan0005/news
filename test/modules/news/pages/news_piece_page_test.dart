import 'package:auth/auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/core/home_page.dart';
import 'package:news/modules/news/pages/all.dart';
import 'package:news/modules/news/repositories/all.dart';
import 'package:news/modules/news/widgets/options_sheet.dart';
import 'package:news/widgets/indicators.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../test_utils/all.dart';

void main() async {
  await loadTranslations();

  final authRepository = MockAuthRepository();
  when(() => authRepository.myId).thenReturn(testUserId);
  when(() => authRepository.uidStream).thenAnswer((_) => const Stream.empty());

  late FakeFirebaseFirestore firestore;

  group('NewsPiecePage', () {
    late Widget testWidget;

    setUp(() {
      firestore = FakeFirebaseFirestore();

      testWidget = getTestWidgetFromInitialLocation(
        initialLocation: '/piece/0',
        overrides: [
          signInStatusStreamProvider.overrideWithValue(
              const AsyncValue.data(SignInStatus(isSignedIn: false))),
          authRepositoryProvider.overrideWithValue(authRepository),
          firestoreProvider.overrideWithValue(firestore),
        ],
      );
    });

    testWidgets('initially loading', (tester) async {
      await tester.pumpWidget(testWidget);
      expect(find.byType(LoadingIndicator), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.byType(LoadingIndicator), findsNothing);
    });

    testWidgets('indicates if piece is not found', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.text('This news piece was not found'), findsOneWidget);
    });

    testWidgets('error indicator is shown in case of error', (tester) async {
      // Error response needs to be mocked.
      final historyRepository = MockHistoryRepository();
      when(() => historyRepository.getPieceFromHistory('0', null))
          .thenAnswer((_) async => throw Exception());

      // Create new test widget with additional override.
      testWidget = getTestWidgetFromInitialLocation(
        initialLocation: '/piece/0',
        overrides: (testWidget as ProviderScope).overrides
          ..add(historyRepositoryProvider.overrideWithValue(historyRepository)),
      );

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byType(ErrorIndicator), findsOneWidget);
    });

    testWidgets('required elements are present when piece is found',
        (tester) async {
      await addTestPieceToHistory(firestore, 0, false);

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byType(NewsPiecePage), findsOneWidget);
      expect(find.byType(WebView), findsOneWidget);
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('back button works', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byType(NewsPiecePage), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.byType(NewsPiecePage), findsNothing);
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('options sheet can be opened and closed', (tester) async {
      await addTestPieceToHistory(firestore, 0, false);

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      expect(find.byType(OptionsSheet), findsNothing);

      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();
      expect(find.byType(OptionsSheet), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.byType(OptionsSheet), findsNothing);
    });

    testWidgets('going to source page works', (tester) async {
      await addTestPieceToHistory(firestore, 0, false);

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      expect(find.byType(OptionsSheet), findsOneWidget);

      await tester.tap(find.byIcon(Icons.open_in_new));
      await tester.pumpAndSettle();

      expect(find.byType(SourcePage), findsOneWidget);
      expect(find.byType(OptionsSheet), findsNothing);
    });

    testWidgets('saving piece from options sheet works', (tester) async {
      await addTestPieceToHistory(firestore, 0, false);

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      // Save news piece.
      await tester.tap(find.byIcon(Icons.star_border));
      await tester.pumpAndSettle();

      // Snackbar is shown then hidden after 2 sec.
      expect(find.byType(SnackBar), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(SnackBar), findsNothing);

      // When we open options sheet now, star icon should change to delete icon.
      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete_outlined), findsOneWidget);
      expect(find.byIcon(Icons.star_border), findsNothing);
    });

    testWidgets('opening this page via "saved/:id" route works',
        (tester) async {
      await addTestSavedNewsToFirestore(firestore, 1);

      testWidget = getTestWidgetFromInitialLocation(
        initialLocation: '/saved/0',
        overrides: (testWidget as ProviderScope).overrides,
      );

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byType(NewsPiecePage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.more_horiz));
      await tester.pumpAndSettle();

      // Options sheet shows the option to remove from saved instead of saving.
      expect(find.byIcon(Icons.delete_outlined), findsOneWidget);
      expect(find.byIcon(Icons.star_border), findsNothing);
    });
  });
}
