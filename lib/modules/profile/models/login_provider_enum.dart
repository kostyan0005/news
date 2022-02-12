import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news/config/twitter_params.dart';

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

  Future<SignInResult> Function() getConnectionFunction() {
    switch (this) {
      case LoginProvider.google:
        return () => AuthRepository.instance.connectWithGoogle();
      case LoginProvider.facebook:
        return () => AuthRepository.instance.connectWithFacebook();
      case LoginProvider.twitter:
        return () => AuthRepository.instance.connectWithTwitter(
            twitterApiKey, twitterSecretKey, twitterRedirectUri);
      case LoginProvider.logout:
        throw Exception('This case is not supported');
    }
  }
}
