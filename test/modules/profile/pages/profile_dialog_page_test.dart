import 'dart:async';

import 'package:auth/auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news/core/firestore_provider.dart';
import 'package:news/modules/profile/pages/locale_selection_page.dart';
import 'package:news/modules/profile/pages/profile_dialog_page.dart';
import 'package:news/modules/profile/widgets/login_provider_card.dart';

import '../../../test_utils/all.dart';

void main() async {
  await loadTranslations();

  final authRepository = MockAuthRepository();
  when(() => authRepository.myId).thenReturn(testUserId);
  when(() => authRepository.uidStream).thenAnswer((_) => const Stream.empty());

  late FakeFirebaseFirestore firestore;

  group('ProfileDialogPage', () {
    late Widget testWidget;

    setUp(() {
      firestore = FakeFirebaseFirestore();

      testWidget = getTestWidgetFromInitialLocation(
        initialLocation: '/',
        overrides: [
          signInStatusStreamProvider.overrideWith(
              (_) => Stream.value(const SignInStatus(isSignedIn: false))),
          authRepositoryProvider.overrideWithValue(authRepository),
          firestoreProvider.overrideWithValue(firestore),
        ],
      );
    });

    Finder findProfileButton() => find.byKey(const ValueKey('profileButton'));

    testWidgets('required elements are present', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.tap(findProfileButton());
      await tester.pumpAndSettle();

      expect(find.byType(ProfileDialogPage), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
      expect(find.byType(ExpansionTile), findsOneWidget);
      expect(find.text('Sign in/out'), findsOneWidget);
      expect(find.text('Not signed in', findRichText: true), findsOneWidget);
      expect(find.text('Language and region'), findsOneWidget);
    });

    testWidgets('dialog is closed when close icon is tapped', (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.tap(findProfileButton());
      await tester.pumpAndSettle();

      expect(find.byType(ProfileDialogPage), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.byType(ProfileDialogPage), findsNothing);
    });

    testWidgets('dialog is closed when area outside dialog is tapped',
        (tester) async {
      await tester.pumpWidget(testWidget);
      await tester.tap(findProfileButton());
      await tester.pumpAndSettle();

      expect(find.byType(ProfileDialogPage), findsOneWidget);

      await tester.tapAt(const Offset(0, 0));
      await tester.pumpAndSettle();

      expect(find.byType(ProfileDialogPage), findsNothing);
    });

    testWidgets(
      'tapping on language and region tile opens the respective page',
      (tester) async {
        await tester.pumpWidget(testWidget);
        await tester.tap(findProfileButton());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Language and region'));
        await tester.pumpAndSettle();

        expect(find.byType(LocaleSelectionPage), findsOneWidget);
        expect(find.byType(ProfileDialogPage), findsNothing);
      },
    );

    testWidgets(
      'tapping on sign in/out tile reveals 3 buttons when not signed in',
      (tester) async {
        await tester.pumpWidget(testWidget);
        await tester.tap(findProfileButton());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Sign in/out'));
        await tester.pumpAndSettle();

        expect(find.byType(LoginProviderCard), findsNWidgets(3));
        expect(find.text('Sign in with Google'), findsOneWidget);
        expect(find.text('Sign in with Facebook'), findsOneWidget);
        expect(find.text('Sign in with Twitter'), findsOneWidget);
        expect(find.text('Sign out'), findsNothing);
      },
    );

    testWidgets(
      'when signed in with google, show connect with '
      'facebook/twitter and sign out buttons',
      (tester) async {
        const signInStatusOverride =
            SignInStatus(isSignedIn: true, withGoogle: true);

        testWidget = getTestWidgetFromInitialLocation(
          initialLocation: '/',
          overrides: (testWidget as ProviderScope).overrides
            ..add(
              signInStatusStreamProvider
                  .overrideWith((_) => Stream.value(signInStatusOverride)),
            ),
        );

        await tester.pumpWidget(testWidget);
        await tester.tap(findProfileButton());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Sign in/out'));
        await tester.pumpAndSettle();

        expect(find.byType(LoginProviderCard), findsNWidgets(3));
        expect(find.text('Connect with Google'), findsNothing);
        expect(find.text('Connect with Facebook'), findsOneWidget);
        expect(find.text('Connect with Twitter'), findsOneWidget);
        expect(find.text('Sign out'), findsOneWidget);
      },
    );

    testWidgets('successfully signing in flows as expected', (tester) async {
      final signInCompleter = Completer<SignInStatus>();
      final signInStatusStream = Stream.fromFutures([
        Future.value(const SignInStatus(isSignedIn: false)),
        signInCompleter.future,
      ]);

      when(() => authRepository.connectWithGoogle()).thenAnswer((_) async {
        await Future.delayed(Duration.zero); // Wait till next frame.
        signInCompleter
            .complete(const SignInStatus(isSignedIn: true, withGoogle: true));
        return SignInResult.success;
      });

      testWidget = getTestWidgetFromInitialLocation(
        initialLocation: '/',
        overrides: (testWidget as ProviderScope).overrides
          ..add(signInStatusStreamProvider.overrideWithProvider(
              StreamProvider.autoDispose((_) => signInStatusStream))),
      );

      await tester.pumpWidget(testWidget);
      await tester.tap(findProfileButton());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign in/out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign in with Google'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Sign in with Google'), findsNothing);
      expect(find.text('Sign in with Facebook'), findsOneWidget);
      expect(find.byType(LoginProviderCard), findsNWidgets(3));

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Sign out'), findsOneWidget);
      expect(find.text('Connect with Facebook'), findsOneWidget);
      expect(find.text('Connect with Google'), findsNothing);
      expect(find.byType(LoginProviderCard), findsNWidgets(3));

      expect(find.byType(SnackBar), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('signing out flows as expected', (tester) async {
      final signOutCompleter = Completer<SignInStatus>();
      final signInStatusStream = Stream.fromFutures([
        Future.value(const SignInStatus(isSignedIn: true, withGoogle: true)),
        signOutCompleter.future,
      ]);

      when(() => authRepository.signOut()).thenAnswer((_) async {
        await Future.delayed(Duration.zero); // Wait till next frame.
        signOutCompleter.complete(const SignInStatus(isSignedIn: false));
      });

      testWidget = getTestWidgetFromInitialLocation(
        initialLocation: '/',
        overrides: (testWidget as ProviderScope).overrides
          ..add(signInStatusStreamProvider.overrideWithProvider(
              StreamProvider.autoDispose((_) => signInStatusStream))),
      );

      await tester.pumpWidget(testWidget);
      await tester.tap(findProfileButton());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign in/out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign out'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Sign out'), findsNothing);
      expect(find.text('Connect with Facebook'), findsOneWidget);
      expect(find.byType(LoginProviderCard), findsNWidgets(3));

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Sign in with Facebook'), findsOneWidget);
      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.byType(LoginProviderCard), findsNWidgets(3));

      expect(find.byType(SnackBar), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('connecting with second provider flows as expected',
        (tester) async {
      final connectWithFacebookCompleter = Completer<SignInStatus>();
      final signInStatusStream = Stream.fromFutures([
        Future.value(const SignInStatus(isSignedIn: true, withGoogle: true)),
        connectWithFacebookCompleter.future,
      ]);

      when(() => authRepository.connectWithFacebook()).thenAnswer((_) async {
        await Future.delayed(Duration.zero); // Wait till next frame.
        connectWithFacebookCompleter.complete(const SignInStatus(
            isSignedIn: true, withGoogle: true, withFacebook: true));
        return SignInResult.success;
      });

      testWidget = getTestWidgetFromInitialLocation(
        initialLocation: '/',
        overrides: (testWidget as ProviderScope).overrides
          ..add(signInStatusStreamProvider.overrideWithProvider(
              StreamProvider.autoDispose((_) => signInStatusStream))),
      );

      await tester.pumpWidget(testWidget);
      await tester.tap(findProfileButton());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign in/out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Connect with Facebook'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Connect with Facebook'), findsNothing);
      expect(find.byType(LoginProviderCard), findsNWidgets(3));

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(LoginProviderCard), findsNWidgets(2));

      expect(find.byType(SnackBar), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('cancelled signing in flows as expected', (tester) async {
      when(() => authRepository.connectWithGoogle()).thenAnswer((_) =>
          Future.delayed(Duration.zero).then((_) => SignInResult.cancelled));

      await tester.pumpWidget(testWidget);
      await tester.tap(findProfileButton());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign in/out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign in with Google'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Sign in with Google'), findsNothing);
      expect(find.byType(LoginProviderCard), findsNWidgets(3));

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Sign out'), findsNothing);
      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.byType(LoginProviderCard), findsNWidgets(3));
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('failed signing in flows as expected', (tester) async {
      when(() => authRepository.connectWithGoogle()).thenAnswer((_) =>
          Future.delayed(Duration.zero).then((_) => SignInResult.failed));

      await tester.pumpWidget(testWidget);
      await tester.tap(findProfileButton());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign in/out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sign in with Google'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Sign in with Google'), findsNothing);
      expect(find.byType(LoginProviderCard), findsNWidgets(3));

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Sign out'), findsNothing);
      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.byType(LoginProviderCard), findsNWidgets(3));

      final errorSnackBarFinder = find.byWidgetPredicate((w) =>
          w is SnackBar &&
          w.action is SnackBarAction &&
          w.content is Text &&
          (w.content as Text)
              .data!
              .startsWith('An unexpected error has occurred.'));

      // Error message is shown not for 2 but for 5 seconds.
      expect(errorSnackBarFinder, findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(errorSnackBarFinder, findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      expect(errorSnackBarFinder, findsNothing);
    });

    testWidgets('account in use dialog is shown when needed', (tester) async {
      when(() => authRepository.connectWithFacebook()).thenAnswer((_) =>
          Future.delayed(Duration.zero).then((_) => SignInResult.accountInUse));

      const signInStatusOverride =
          SignInStatus(isSignedIn: true, withGoogle: true);

      testWidget = getTestWidgetFromInitialLocation(
        initialLocation: '/',
        overrides: (testWidget as ProviderScope).overrides
          ..add(
            signInStatusStreamProvider
                .overrideWith((_) => Stream.value(signInStatusOverride)),
          ),
      );

      await tester.pumpWidget(testWidget);
      await tester.tap(findProfileButton());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign in/out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Connect with Facebook'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Connect with Facebook'), findsNothing);
      expect(find.byType(LoginProviderCard), findsNWidgets(3));

      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Account already in use'), findsOneWidget);
      expect(find.textContaining('This account is already connected'),
          findsOneWidget);
      expect(find.byType(TextButton), findsNWidgets(2));
      expect(find.text('Sign out').hitTestable(), findsOneWidget);
      expect(find.text('Dismiss'), findsOneWidget);

      await tester.tap(find.text('Dismiss'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Connect with Facebook'), findsOneWidget);
      expect(find.byType(LoginProviderCard), findsNWidgets(3));
    });

    testWidgets('can sign out via account in use dialog', (tester) async {
      final signOutCompleter = Completer<SignInStatus>();
      final signInStatusStream = Stream.fromFutures([
        Future.value(const SignInStatus(isSignedIn: true, withGoogle: true)),
        signOutCompleter.future,
      ]);

      when(() => authRepository.connectWithFacebook()).thenAnswer((_) =>
          Future.delayed(Duration.zero).then((_) => SignInResult.accountInUse));

      when(() => authRepository.signOut()).thenAnswer((_) async =>
          signOutCompleter.complete(const SignInStatus(isSignedIn: false)));

      testWidget = getTestWidgetFromInitialLocation(
        initialLocation: '/',
        overrides: (testWidget as ProviderScope).overrides
          ..add(signInStatusStreamProvider.overrideWithProvider(
              StreamProvider.autoDispose((_) => signInStatusStream))),
      );

      await tester.pumpWidget(testWidget);
      await tester.tap(findProfileButton());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign in/out'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Connect with Facebook'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Sign out'), findsOneWidget);
      expect(find.text('Sign in with Google'), findsNothing);
      expect(find.byType(LoginProviderCard), findsNWidgets(3));

      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.text('Sign out').hitTestable());
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Sign out'), findsNothing);
      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.byType(LoginProviderCard), findsNWidgets(3));

      expect(find.byType(SnackBar), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(SnackBar), findsNothing);
    });
  });
}
