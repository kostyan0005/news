enum LoginProvider { google, facebook, twitter, logout }

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
}
