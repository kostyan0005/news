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
        initialLocation: '/search/Search+request',
        overrides: [
          signInStatusStreamProvider.overrideWithValue(
              const AsyncValue.data(SignInStatus(isSignedIn: false))),
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

    // todo
  });
}
