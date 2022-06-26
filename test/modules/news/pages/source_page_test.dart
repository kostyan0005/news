import 'package:auth/auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/core/home_page.dart';
import 'package:news/modules/news/pages/source_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../test_utils/all.dart';

void main() async {
  await loadTranslations();

  final authRepository = MockAuthRepository();
  when(() => authRepository.myId).thenReturn(testUserId);
  when(() => authRepository.uidStream).thenAnswer((_) => const Stream.empty());

  late FakeFirebaseFirestore firestore;

  group('SourcePage', () {
    late Widget testWidget;

    setUp(() {
      firestore = FakeFirebaseFirestore();

      testWidget = getTestWidgetFromInitialLocation(
        initialLocation: '/source?name=The+New+York+Times'
            '&link=https%3A%2F%2Fwww.nytimes.com',
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

      final webviewWithInitialUrlFinder = find.byWidgetPredicate(
          (w) => w is WebView && w.initialUrl == 'https://www.nytimes.com');

      expect(find.byType(SourcePage), findsOneWidget);
      expect(find.text('The New York Times'), findsOneWidget);
      expect(webviewWithInitialUrlFinder, findsOneWidget);
      expect(find.byIcon(Icons.ios_share), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
    });

    testWidgets(
      'if name or source query params are not provided, '
      'tells that source cannot be found',
      (tester) async {
        testWidget = getTestWidgetFromInitialLocation(
          initialLocation: '/source?',
          overrides: (testWidget as ProviderScope).overrides,
        );

        await tester.pumpWidget(testWidget);

        expect(find.text('This news source was not found'), findsOneWidget);
        expect(find.byType(WebView), findsNothing);
        expect(find.byIcon(Icons.ios_share), findsNothing);
      },
    );

    testWidgets('back button works', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.byType(SourcePage), findsOneWidget);

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.byType(SourcePage), findsNothing);
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
