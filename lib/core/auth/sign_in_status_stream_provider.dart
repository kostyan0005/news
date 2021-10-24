import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository.dart';

final signInStatusStreamProvider = StreamProvider.autoDispose<SignInStatus>(
  (ref) => ref.read(authRepositoryProvider).userChangesStream.map((user) {
    if (user == null || user.isAnonymous) {
      return SignInStatus(isSignedIn: false);
    } else {
      final providerIds =
          user.providerData.map((info) => info.providerId).toList();

      return SignInStatus(
        isSignedIn: true,
        withGoogle: providerIds.contains(GoogleAuthProvider.PROVIDER_ID),
        withFacebook: providerIds.contains(FacebookAuthProvider.PROVIDER_ID),
        withTwitter: providerIds.contains(TwitterAuthProvider.PROVIDER_ID),
        withApple: providerIds.contains('apple.com'), // no constant here
      );
    }
  }),
);

class SignInStatus {
  final bool isSignedIn;
  final bool withGoogle;
  final bool withFacebook;
  final bool withTwitter;
  final bool withApple;

  const SignInStatus({
    required this.isSignedIn,
    this.withGoogle = false,
    this.withFacebook = false,
    this.withTwitter = false,
    this.withApple = false,
  });
}
