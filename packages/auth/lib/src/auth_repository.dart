import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';

/// The result of the sign-in attempt.
enum SignInResult {
  success,
  failed,
  cancelled,
  accountInUse,
}

/// The provider of [AuthRepository] instance.
final authRepositoryProvider = Provider((_) => AuthRepository.instance);

/// The singleton repository which handles signing in/connecting the user with
/// different authentication providers, getting the result of these sign-in
/// attempts and signing out.
class AuthRepository {
  static final _instance = AuthRepository();

  /// A single instance of this repository.
  static AuthRepository get instance => _instance;

  /// Whether [_auth] instance has already been set.
  ///
  /// Needed in case multiple integration tests are running sequentially.
  bool _isSet = false;

  late final FirebaseAuth _auth;
  late final bool _isProd;

  User get _me => _auth.currentUser!;
  String get myId => _me.uid;

  /// The stream of current user data changes.
  Stream<User> get userChangesStream =>
      _auth.userChanges().where((u) => u != null).cast<User>();

  /// The stream of current user uid changes.
  Stream<String> get uidStream => userChangesStream.map((u) => u.uid);

  /// Sets the [auth] instance passed from the core application and specifies
  /// which environment is used.
  ///
  /// If the [auth] instance has already been set previously, do not reset it.
  void setAuthInstance(FirebaseAuth auth, bool isProd) {
    if (!_isSet) {
      _auth = auth;
      _isProd = isProd;
      _isSet = true;
    }
  }

  /// Signs the user in anonymously if he is not signed in yet.
  Future<void> signInAnonymouslyIfNeeded() async {
    if (kIsWeb) {
      // On the web, we need to wait until the first auth state is emitted
      // in order to have up-to-date user data.
      await _auth.authStateChanges().first;
    }

    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
    }
  }

  /// Signs the user out and immediately signs him in anonymously.
  ///
  /// This is done so that the user is always signed in with some account
  /// (the anonymous one by default) while using the app.
  Future<void> signOut() async {
    await _auth.signOut();
    await _auth.signInAnonymously();
  }

  /// Tries to connect the current user account with the authentication
  /// provider that has the given [credential].
  ///
  /// Returns the result of this connection attempt, of [SignInResult] type.
  /// Used as a helper function in [connectWithGoogle], [connectWithFacebook]
  /// and [connectWithTwitter] methods.
  Future<SignInResult> _connectWithCredential(AuthCredential credential) async {
    try {
      await _me.linkWithCredential(credential);
      return SignInResult.success;
    } on FirebaseAuthException catch (e, s) {
      if (e.code == 'credential-already-in-use') {
        if (_me.isAnonymous) {
          // The user is not signed in yet.
          try {
            await _auth.signInWithCredential(credential);
            return SignInResult.success;
          } on FirebaseAuthException catch (e, s) {
            // Log an unexpected error.
            Logger().e(e.message, e, s);
            return SignInResult.failed;
          }
        } else {
          // The user is already singed in with the another account.
          return SignInResult.accountInUse;
        }
      } else {
        // Log an unexpected error.
        Logger().e(e.message, e, s);
        return SignInResult.failed;
      }
    }
  }

  /// Tries to connect the current user account with Google auth provider.
  Future<SignInResult> connectWithGoogle() async {
    late final GoogleSignInAccount? googleUser;
    try {
      final googleSignIn = GoogleSignIn(
        clientId: !kIsWeb
            ? null
            : _isProd
                ? '966196182204-j3ml51ve1hlotal7sa0s013mbln3mddd.apps.googleusercontent.com'
                : '174952535817-ia55sjfvjrb7qnlf5l513ugbcrf2prem.apps.googleusercontent.com',
      );

      googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return SignInResult.cancelled;
      }
    } catch (e, s) {
      Logger().e(e, 'Google sign in error', s);
      return SignInResult.failed;
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _connectWithCredential(credential);
  }

  /// Tries to connect the current user account with Facebook auth provider.
  Future<SignInResult> connectWithFacebook() async {
    final result = await FacebookAuth.instance.login();
    final status = result.status;

    if (status == LoginStatus.cancelled) {
      return SignInResult.cancelled;
    } else if (status != LoginStatus.success) {
      Logger().e(result.message);
      return SignInResult.failed;
    }

    final credential =
        FacebookAuthProvider.credential(result.accessToken!.token);
    return await _connectWithCredential(credential);
  }

  /// Tries to connect the current user account with Twitter auth provider.
  Future<SignInResult> connectWithTwitter(
      String apiKey, String secretKey, String redirectUri) async {
    late final AuthResult result;
    try {
      final twitterLogin = TwitterLogin(
        apiKey: apiKey,
        apiSecretKey: secretKey,
        redirectURI: redirectUri,
      );

      result = await twitterLogin.login();
    } catch (e, s) {
      Logger().e(e, 'Twitter login error', s);
      return SignInResult.failed;
    }

    final status = result.status;
    if (status == TwitterLoginStatus.cancelledByUser) {
      return SignInResult.cancelled;
    } else if (status == TwitterLoginStatus.error) {
      Logger().e(result.errorMessage);
      return SignInResult.failed;
    }

    final credential = TwitterAuthProvider.credential(
      accessToken: result.authToken!,
      secret: result.authTokenSecret!,
    );
    return await _connectWithCredential(credential);
  }
}
