import 'package:auth/auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/modules/news/pages/all.dart';

import '../../../test_utils/all.dart';

void main() async {
  await loadTranslations();

  final authRepository = MockAuthRepository();
  when(() => authRepository.myId).thenReturn(testUserId);
  when(() => authRepository.uidStream).thenAnswer((_) => const Stream.empty());

  late FakeFirebaseFirestore firestore;

  group('SearchTextPage', () {
    late Widget testWidget;

    setUp(() {
      firestore = FakeFirebaseFirestore();

      testWidget = getTestWidgetFromInitialLocation(
        initialLocation: '/search',
        overrides: [
          signInStatusStreamProvider.overrideWith(
              (_) => Stream.value(const SignInStatus(isSignedIn: false))),
          authRepositoryProvider.overrideWithValue(authRepository),
          firestoreProvider.overrideWithValue(firestore),
        ],
      );
    });

    testWidgets('required items are present', (tester) async {
      await tester.pumpWidget(testWidget);

      expect(find.byType(SearchTextPage), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(
          find.text('Search for topics, places and sources'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('text can be entered into text field', (tester) async {
      await tester.pumpWidget(testWidget);

      await tester.enterText(find.byType(TextField), 'Search request');
      expect(find.text('Search request'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Another request');
      expect(find.text('Another request'), findsOneWidget);
      expect(find.text('Search request'), findsNothing);
    });

    testWidgets(
      'redirected to search results page after request is entered '
      'and search button is pressed',
      (tester) async {
        await tester.pumpWidget(testWidget);
        await tester.enterText(find.byType(TextField), 'Search request');
        await tester.tap(find.text('Search'));
        await tester.pumpAndSettle();

        expect(find.byType(SearchTextPage), findsNothing);
        expect(find.byType(SearchResultsPage), findsOneWidget);
        expect(find.text('Search request'), findsOneWidget);
      },
    );

    testWidgets(
      'nothing happens if search button is pressed '
      'without entering the request',
      (tester) async {
        await tester.pumpWidget(testWidget);
        await tester.tap(find.text('Search'));
        await tester.pumpAndSettle();

        expect(find.byType(SearchTextPage), findsOneWidget);
        expect(find.byType(SearchResultsPage), findsNothing);
      },
    );
  });
}
