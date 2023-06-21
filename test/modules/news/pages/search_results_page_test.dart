import 'package:auth/auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  group('SearchResultsPage', () {
    late Widget testWidget;

    setUp(() {
      firestore = FakeFirebaseFirestore();

      testWidget = getTestWidgetFromInitialLocation(
        initialLocation: '/search/Search request',
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

      expect(find.byType(SearchResultsPage), findsOneWidget);
      expect(find.text('Search request'), findsOneWidget);
      expect(find.byIcon(Icons.star_border), findsOneWidget);
      expect(find.byIcon(Icons.ios_share), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets('back button returns to search text page', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.byType(SearchTextPage), findsOneWidget);
      expect(find.byType(SearchResultsPage), findsNothing);
    });

    testWidgets('correctly determines if already subscribed to the topic',
        (tester) async {
      await addTestSubscription(firestore, 'Search request');

      await tester.pumpWidget(testWidget);

      expect(find.byIcon(Icons.star_border), findsOneWidget);
      expect(find.byIcon(Icons.star), findsNothing);

      await tester.pump();

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.star_border), findsNothing);
    });

    testWidgets('subscribing to topic works', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.tap(find.byIcon(Icons.star_border));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.star_border), findsNothing);

      // Snackbar is shown then hidden after 2 sec.
      expect(find.byType(SnackBar), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(SnackBar), findsNothing);

      // Go back to home screen and switch to subscriptions page.
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.subscriptions_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(SubscriptionsPage), findsOneWidget);
      expect(find.text('Search request'), findsOneWidget);
    });

    testWidgets('unsubscribing from topic works', (tester) async {
      await addTestSubscription(firestore, 'Search request');

      await tester.pumpWidget(testWidget);
      await tester.pump();
      await tester.tap(find.byIcon(Icons.star));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.star_border), findsOneWidget);
      expect(find.byIcon(Icons.star), findsNothing);

      // Snackbar is shown then hidden after 2 sec.
      expect(find.byType(SnackBar), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(SnackBar), findsNothing);

      // Go back to home screen and switch to subscriptions page.
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.subscriptions_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(SubscriptionsPage), findsOneWidget);
      expect(find.text('Search request'), findsNothing);
    });

    testWidgets('entering this page via "/topic/:text" route works',
        (tester) async {
      testWidget = getTestWidgetFromInitialLocation(
        initialLocation: '/topic/Search request',
        overrides: (testWidget as ProviderScope).overrides,
      );

      await tester.pumpWidget(testWidget);

      expect(find.byType(SearchResultsPage), findsOneWidget);
      expect(find.text('Search request'), findsOneWidget);
    });

    testWidgets('passing "subscribed" parameter to "/topic/:text" route works',
        (tester) async {
      testWidget = getTestWidgetFromInitialLocation(
        initialLocation: '/topic/0?subscribed=true',
        overrides: (testWidget as ProviderScope).overrides,
      );

      await tester.pumpWidget(testWidget);

      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });
}
