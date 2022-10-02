import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news/config/twitter_params.dart';

/// todo
enum LoginProvider {
  google,
  facebook,
  twitter,
  logout,
}

extension LoginProviderExtension on LoginProvider {
  String get name {
    switch (this) {
      case LoginProvider.google:
        return 'Google';
      case LoginProvider.facebook:
        return 'Facebook';
      case LoginProvider.twitter:
        return 'Twitter';
      case LoginProvider.logout:
        return '';
    }
  }

  IconData get icon {
    switch (this) {
      case LoginProvider.google:
        return FontAwesomeIcons.google;
      case LoginProvider.facebook:
        return FontAwesomeIcons.facebook;
      case LoginProvider.twitter:
        return FontAwesomeIcons.twitter;
      case LoginProvider.logout:
        return Icons.logout;
    }
  }

  Future<SignInResult> Function() getConnectionFunction(WidgetRef ref) {
    switch (this) {
      case LoginProvider.google:
        return () => ref.read(authRepositoryProvider).connectWithGoogle();
      case LoginProvider.facebook:
        return () => ref.read(authRepositoryProvider).connectWithFacebook();
      case LoginProvider.twitter:
        return () => ref.read(authRepositoryProvider).connectWithTwitter(
            twitterApiKey, twitterSecretKey, twitterRedirectUri);
      case LoginProvider.logout:
        throw Exception('This case is not supported');
    }
  }
}
