/// The library containing useful authentication helpers.
///
/// Supported functionality includes signing in with different providers,
/// getting the result of the sign-in attempt, stream providers with user uid,
/// photo url and sign-in status data.
library auth;

export 'src/auth_repository.dart'
    show authRepositoryProvider, AuthRepository, SignInResult;
export 'src/uid_notifier_provider.dart' show uidNotifierProvider, UidNotifier;
export 'src/photo_url_stream_provider.dart' show photoUrlStreamProvider;
export 'src/sign_in_status_stream_provider.dart'
    show signInStatusStreamProvider, SignInStatus;
