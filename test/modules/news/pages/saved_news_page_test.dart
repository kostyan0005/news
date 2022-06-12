import 'package:auth/auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/modules/news/models/news_piece_model.dart';
import 'package:news/modules/news/pages/all.dart';
import 'package:news/modules/news/repositories/saved_news_repository.dart';
import 'package:news/modules/news/widgets/news_card.dart';
import 'package:news/widgets/indicators.dart';

import '../../../test_utils/all.dart';

void main() async {
  await loadTranslations();

  final authRepository = MockAuthRepository();
  when(() => authRepository.myId).thenReturn(testUserId);
  when(() => authRepository.uidStream).thenAnswer((_) => const Stream.empty());

  late FakeFirebaseFirestore firestore;

  group('SavedNewsPage', () {
    late Widget testWidget;

    setUp(() {
      firestore = FakeFirebaseFirestore();

      testWidget = getTestWidgetFromInitialTabIndex(
        initialTabIndex: 2,
        overrides: [
          signInStatusStreamProvider.overrideWithValue(
              const AsyncValue.data(SignInStatus(isSignedIn: false))),
          authRepositoryProvider.overrideWithValue(authRepository),
          firestoreProvider.overrideWithValue(firestore),
        ],
      );
    });

    testWidgets('loading initially', (tester) async {
      await tester.pumpWidget(testWidget);
      expect(find.byType(SavedNewsPage), findsOneWidget);
      expect(find.byType(LoadingIndicator), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.byType(LoadingIndicator), findsNothing);
    });

    testWidgets('indicates when there are no saved news', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.text('No news found'), findsOneWidget);
      expect(find.byType(NewsCard), findsNothing);
    });

    testWidgets('indicates when error happens while getting saved news',
        (tester) async {
      // error response needs to be mocked
      final savedNewsRepository = MockSavedNewsRepository();
      when(() => savedNewsRepository.getSavedNewsStream())
          .thenAnswer((_) => Stream.error(Error()));

      // create new test widget with additional override
      testWidget = getTestWidgetFromInitialTabIndex(
        initialTabIndex: 2,
        overrides: (testWidget as ProviderScope).overrides
          ..add(savedNewsRepositoryProvider
              .overrideWithValue(savedNewsRepository)),
      );

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byType(ErrorIndicator), findsOneWidget);
    });

    testWidgets('displays saved news when they exist', (tester) async {
      await addTestSavedNewsToFirestore(firestore, 5);

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byType(NewsCard), findsNWidgets(5));
    });

    testWidgets('saved news stream changes are reflected', (tester) async {
      await addTestSavedNewsToFirestore(firestore, 5);
      final savedNewsRepository = SavedNewsRepository(testUserId, firestore);

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byType(NewsCard), findsNWidgets(5));
      expect(find.text('4'), findsOneWidget);
      expect(find.text('5'), findsNothing);

      await savedNewsRepository
          .savePiece(NewsPiece.fromJson(generateTestPieceJson(5, true)));
      await tester.pumpAndSettle();

      expect(find.byType(NewsCard), findsNWidgets(6));
      expect(find.text('5'), findsOneWidget);

      await savedNewsRepository.removePiece('5');
      await tester.pumpAndSettle();

      expect(find.byType(NewsCard), findsNWidgets(5));
      expect(find.text('5'), findsNothing);
    });

    testWidgets(
      'saved piece can be removed from the list by pressing '
      'on remove from saved list tile inside options sheet',
      (tester) async {
        await addTestSavedNewsToFirestore(firestore, 5);

        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        expect(find.byType(NewsCard), findsNWidgets(5));
        expect(find.text('0'), findsOneWidget);

        await tester.longPress(find.text('0'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Remove from saved news'));
        await tester.pumpAndSettle();

        // todo: check if snackbar is shown

        expect(find.byType(NewsCard), findsNWidgets(4));
        expect(find.text('0'), findsNothing);
      },
    );
  });
}
