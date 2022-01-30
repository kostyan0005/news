import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_repository.dart';

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

final signInStatusStreamProvider = StreamProvider.autoDispose<SignInStatus>(
  (_) => AuthRepository.instance.userChangesStream.map((user) {
    if (user.isAnonymous) {
      return const SignInStatus(
        isSignedIn: false,
      );
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
