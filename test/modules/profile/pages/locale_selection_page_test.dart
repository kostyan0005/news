import 'package:auth/auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/modules/profile/pages/locale_selection_page.dart';

import '../../../test_utils/all.dart';

void main() async {
  await loadTranslations();

  final authRepository = MockAuthRepository();
  when(() => authRepository.myId).thenReturn(testUserId);
  when(() => authRepository.uidStream).thenAnswer((_) => const Stream.empty());

  late FakeFirebaseFirestore firestore;

  group('LocaleSelectionPage', () {
    late Widget testWidget;

    setUp(() {
      firestore = FakeFirebaseFirestore();

      testWidget = getTestWidgetFromInitialLocation(
        initialLocation: '/locale',
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

      expect(find.byType(LocaleSelectionPage), findsOneWidget);
      expect(find.text('Language and region'), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
      expect(find.text('English (United States)'), findsOneWidget);
      expect(find.text('Русский (Украина)'), findsOneWidget);
      // No item is selected initially, as stream hasn't returned anything yet.
      expect(find.byIcon(Icons.check), findsNothing);
    });

    testWidgets('English is selected initially by default', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byKey(const ValueKey('englishCheck')), findsOneWidget);
    });

    testWidgets('Russian is selected if it is set in user settings',
        (tester) async {
      await firestore.collection('users').doc(testUserId).set({
        'locale': 'ru_UA',
      });

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byKey(const ValueKey('russianCheck')), findsOneWidget);
    });

    testWidgets('switching language from English to Russian works',
        (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('englishCheck')), findsOneWidget);
      expect(find.byKey(const ValueKey('russianCheck')), findsNothing);

      await tester.tap(find.text('Русский (Украина)'));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('russianCheck')), findsOneWidget);
      expect(find.byKey(const ValueKey('englishCheck')), findsNothing);

      // Snackbar is shown then hidden after 2 sec.
      expect(find.byType(SnackBar), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets(
      'when language is switched from English to Russian, '
      'it is reflected in headline tab titles',
      (tester) async {
        testWidget = getTestWidgetFromInitialLocation(
          initialLocation: '/',
          overrides: (testWidget as ProviderScope).overrides,
        );

        await tester.pumpWidget(testWidget);
        await tester.pumpAndSettle();

        expect(find.text('Latest'), findsOneWidget);
        expect(find.text('U.S.'), findsOneWidget);
        expect(find.text('Последние'), findsNothing);
        expect(find.text('Украина'), findsNothing);

        // Open profile dialog and go to locale selection page.
        await tester.tap(find.byKey(const ValueKey('profileButton')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Language and region'));
        await tester.pumpAndSettle();

        // Switch language from English to Russian and go back to home page.
        await tester.tap(find.text('Русский (Украина)'));
        await tester.tap(find.byType(BackButton));
        await tester.pumpAndSettle();

        expect(find.text('Последние'), findsOneWidget);
        expect(find.text('Украина'), findsOneWidget);
        expect(find.text('Latest'), findsNothing);
        expect(find.text('U.S.'), findsNothing);
      },
    );
  });
}
