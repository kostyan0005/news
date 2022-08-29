import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository.dart';

/// The sign-in status of the user.
///
/// Indicates whether the user is signed or not and tells which
/// authentication providers are connected with the corresponding account.
class SignInStatus {
  final bool isSignedIn;
  final bool withGoogle;
  final bool withFacebook;
  final bool withTwitter;

  const SignInStatus({
    required this.isSignedIn,
    this.withGoogle = false,
    this.withFacebook = false,
    this.withTwitter = false,
  });
}

/// The provider of the current user [SignInStatus] stream.
final signInStatusStreamProvider = StreamProvider.autoDispose<SignInStatus>(
  (ref) => ref.read(authRepositoryProvider).userChangesStream.map((user) {
    if (user.isAnonymous) {
      return const SignInStatus(isSignedIn: false);
    } else {
      final providerIds =
          user.providerData.map((info) => info.providerId).toList();

      return SignInStatus(
        isSignedIn: true,
        withGoogle: providerIds.contains(GoogleAuthProvider.PROVIDER_ID),
        withFacebook: providerIds.contains(FacebookAuthProvider.PROVIDER_ID),
        withTwitter: providerIds.contains(TwitterAuthProvider.PROVIDER_ID),
        // withApple: providerIds.contains('apple.com'),
      );
    }
  }),
);
