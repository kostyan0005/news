import 'package:auth/auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/core/firestore_provider.dart';

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
          signInStatusStreamProvider.overrideWithValue(
              const AsyncValue.data(SignInStatus(isSignedIn: false))),
          authRepositoryProvider.overrideWithValue(authRepository),
          firestoreProvider.overrideWithValue(firestore),
        ],
      );
    });

    testWidgets('required items are present', (tester) async {
      await tester.pumpWidget(testWidget);

      // todo
    });
  });
}
