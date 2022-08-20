import 'package:auth/auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/modules/news/models/search_query_model.dart';
import 'package:news/modules/news/pages/all.dart';
import 'package:news/modules/news/repositories/all.dart';
import 'package:news/modules/news/widgets/subscription_item.dart';
import 'package:news/utils/rss_utils.dart';
import 'package:news/widgets/indicators.dart';

import '../../../test_utils/all.dart';

void main() async {
  await loadTranslations();

  final authRepository = MockAuthRepository();
  when(() => authRepository.myId).thenReturn(testUserId);
  when(() => authRepository.uidStream).thenAnswer((_) => const Stream.empty());

  final newsSearchRepository = MockNewsSearchRepository();
  when(() => newsSearchRepository.getNewsFromRssUrl(
      getSearchQueryNewsUrl('0', 'en_US'))).thenAnswer((_) async => []);

  late FakeFirebaseFirestore firestore;

  group('HeadlineTabsPage', () {
    late Widget testWidget;

    setUp(() {
      firestore = FakeFirebaseFirestore();

      testWidget = getTestWidgetFromInitialTabIndex(
        initialTabIndex: 1,
        overrides: [
          signInStatusStreamProvider.overrideWithValue(
              const AsyncValue.data(SignInStatus(isSignedIn: false))),
          authRepositoryProvider.overrideWithValue(authRepository),
          newsSearchRepositoryProvider.overrideWithValue(newsSearchRepository),
          firestoreProvider.overrideWithValue(firestore),
        ],
      );
    });

    testWidgets('loading initially', (tester) async {
      await tester.pumpWidget(testWidget);
      expect(find.byType(SubscriptionsPage), findsOneWidget);
      expect(find.byType(LoadingIndicator), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.byType(LoadingIndicator), findsNothing);
    });

    testWidgets('indicates when there are no subscriptions', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.text('You have no subscriptions'), findsOneWidget);
      expect(find.byType(SubscriptionItem), findsNothing);
    });

    testWidgets('indicates when error happens while getting subscriptions',
        (tester) async {
      // Error response needs to be mocked.
      final subscriptionsRepository = MockSubscriptionsRepository();
      when(() => subscriptionsRepository.getSubscriptionsStream())
          .thenAnswer((_) => Stream.error(Error()));

      // Create new test widget with additional override.
      testWidget = getTestWidgetFromInitialTabIndex(
        initialTabIndex: 1,
        overrides: (testWidget as ProviderScope).overrides
          ..add(subscriptionsRepositoryProvider
              .overrideWithValue(subscriptionsRepository)),
      );

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byType(ErrorIndicator), findsOneWidget);
    });

    testWidgets('displays subscriptions when they exist', (tester) async {
      await addTestSubscriptionsToFirestore(firestore, 5);

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byType(SubscriptionItem), findsNWidgets(5));
    });

    testWidgets('subscription stream changes are reflected', (tester) async {
      await addTestSubscriptionsToFirestore(firestore, 5);
      final subscriptionsRepository =
          SubscriptionsRepository(testUserId, firestore);

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byType(SubscriptionItem), findsNWidgets(5));
      expect(find.text('4'), findsOneWidget);
      expect(find.text('5'), findsNothing);

      await subscriptionsRepository
          .subscribe(SearchQuery.fromJson(generateTestSubscriptionJson(5)));
      await tester.pumpAndSettle();

      expect(find.byType(SubscriptionItem), findsNWidgets(6));
      expect(find.text('5'), findsOneWidget);

      await subscriptionsRepository.unsubscribe('5');
      await tester.pumpAndSettle();

      expect(find.byType(SubscriptionItem), findsNWidgets(5));
      expect(find.text('5'), findsNothing);
    });

    testWidgets(
      'subscription can be removed from list by pressing on delete icon '
      '+ snackbar is shown',
      (tester) async {
        await addTestSubscriptionsToFirestore(firestore, 5);

        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        expect(find.byType(SubscriptionItem), findsNWidgets(5));
        expect(find.text('0'), findsOneWidget);

        await tester.tap(find.byKey(const ValueKey('0_delete')));
        await tester.pumpAndSettle();

        expect(find.byType(SubscriptionItem), findsNWidgets(4));
        expect(find.text('0'), findsNothing);

        // Snackbar is shown then hidden after 2 sec.
        expect(find.byType(SnackBar), findsOneWidget);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        expect(find.byType(SnackBar), findsNothing);
      },
    );

    testWidgets('subscription page is opened when pressed on one of the items',
        (tester) async {
      await addTestSubscriptionsToFirestore(firestore, 5);

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byType(SubscriptionsPage), findsOneWidget);
      expect(find.text('0'), findsOneWidget); // Card text.

      await tester.tap(find.text('0'));
      await tester.pumpAndSettle();

      expect(find.byType(SubscriptionsPage), findsNothing);
      expect(find.byType(SearchResultsPage), findsOneWidget);
      expect(find.text('0'), findsOneWidget); // Page title.
    });

    testWidgets('subscriptions can be scrolled', (tester) async {
      await addTestSubscriptionsToFirestore(firestore, 10);

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.text('9'), findsOneWidget);
      expect(find.text('0'), findsNothing);

      // Scroll down.
      await tester.scrollUntilVisible(find.text('0'), 500,
          scrollable: find.byType(Scrollable).first);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('9'), findsNothing);

      // Scroll up.
      await tester.scrollUntilVisible(find.text('9'), -500,
          scrollable: find.byType(Scrollable).first);
      expect(find.text('9'), findsOneWidget);
      expect(find.text('0'), findsNothing);
    });
  });
}
